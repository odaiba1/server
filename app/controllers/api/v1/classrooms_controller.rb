module Api
  module V1
    class ClassroomsController < Api::V1::BaseController
      acts_as_token_authentication_handler_for User
      before_action :set_classroom, only: %i[show edit update destroy initiate_all_work_groups conclude_all_work_groups]

      def index
        @classrooms = policy_scope(Classroom)
        render json: @classrooms.map(&:parse_for_dashboard).to_json
      end

      def show; end

      def edit
        render :show
      end

      def update
        if @classroom.update(classroom_params)
          render :show
        else
          render_error
        end
      end

      def new
        @classroom = Classroom.new
        authorize @classroom
        render json: @classroom.to_json
      end

      def create
        @classroom = Classroom.new(classroom_params)
        @classroom.user = current_user
        authorize @classroom
        if @classroom.save
          render :show
        else
          render_error
        end
      end

      def destroy
        @classroom.destroy
        render json: {}
      end

      def initiate_all_work_groups
        work_groups = @classroom.work_groups.where(aasm_state: :created)
        work_groups.update_all(aasm_state: :in_progress)
        render json: @classroom.work_groups.where(aasm_state: :in_progress).to_json
      end

      def conclude_all_work_groups
        work_groups = @classroom.work_groups.where(aasm_state: :in_progress)
        # need to make sure that all the worksheets are updated before sending the emails
        mail_worksheets_to_teacher(work_groups)
        work_groups.each { |work_group| mail_worksheets(work_group) }
        work_groups.update_all(aasm_state: :done)
        render json: @classroom.work_groups.where(aasm_state: :done).to_json
      end

      private

      def mail_worksheets(work_group)
        DemoMailer.with(
          students: work_group.students.to_a,
          student_group: work_group,
          image_urls: work_group.worksheets.pluck(:image_url)
        ).send_worksheets.deliver_later
        work_group.update(worksheet_email_sent: true)
      end

      def mail_worksheets_to_teacher(work_groups)
        DemoMailer.with(
          teacher: work_groups.first.classroom.teacher,
          work_groups: work_groups.map do |w|
                         Hash[:users, w.students.pluck(:name, :pen_colour).map do |name, pen_colour|
                                        { 'name' => name, 'pen_colour' => pen_colour }
                                      end,
                              :worksheets, ['image_url', w.worksheets.pluck(:image_url)]]
                       end
        ).send_worksheets_to_teacher.deliver_later
      end

      def set_classroom
        @classroom = Classroom.find(params[:id])
        authorize @classroom
      end

      def classroom_params
        params.require(:classroom).permit(:subject, :grade, :group, :start_time, :end_time)
      end

      def render_error
        render json: { errors: @classroom.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end
end
