# API Documentation Odaiba

## RESTful endpoints

### POST /login

_Request Body_
```
{
    username: "qweqwe",
    password: "qweqwe"
}
```

_Response (200)_
```
{
    id: 1,
    name: "qweqwe",
    role: "student or teacher",
    token: "randomtoken"
}
```

### GET /classrooms

_Request Header_
```
{
    token: "random"
}
```


_Response (200)_
```
[
    {
        id: 1,
        student_id: 1,
        classroom: 1,
        Classroom: {
            id: 1,
            name: "English class",
            teacher_id: 1,
            Teacher: {
                id: 1,
                name: "Lolita"
            }
        }
    }
]
```

### GET /classrooms/ _:id_

_Request Header_
```
{
    token: "random"
}
```

_Response (200)_
```

{
    id: 1,
    name: "English class",
    teacher_id: 1,
    Teacher: {
        id: 1,
        name: "Lolita"
    },
    Students: [
        {
            id: 1,
            name: "qweqwe"
        },
        ...
    ]
}

```

### GET /classrooms/_:id_/work_groups


_Request Header_
```
{
    token: "random"
}
```

_Response (200)_
```
[
    {
        id: 1,
        name: "group 1",
        video_call_code: "1"
        session_time: 900000,
        turn_time: 3000
        score: 0
        answered: 0
        aasm_state: "on_progress"
        start_at: datetime
        classroom_id: 1
        Classroom: {
            id: 1,
            teacher_id: 1,
        },
        "created_at" datetime
        "updated_at" datetime
    },
    ...
]

```


### GET /classrooms/_:id_/work_groups/_:id_


_Request Header_
```
{
    token: "random"
}
```
_Response (200)_

```
{
    id: 1,
    name: "group 1",
    video_call_code: "1"
    session_time: 900000,
    turn_time: 3000
    score: 0
    answered: 0
    aasm_state: "on_progress"
    start_at: datetime
    classroom_id: 1
    Classroom: {
        id: 1,
        teacher_id: 1,
    },
    "created_at" datetime
    "updated_at" datetime
}
```

### PUT /classrooms/_:id_/work_groups/_:id_

_Request Header_
```
{
    token: "random"
}
```

_Request Body_
```
{
    name: "group 1",
    video_call_code: "1"
    session_time: 900000,
    turn_time: 3000
    score: 0
    answered: 0
    aasm_state: "on_progress"
    start_at: datetime
    classroom_id: 1
}
```

_Response (200)_

```
    {
        id: 1,
        message: "successfully updated"
    }
```


GET /classrooms/_:id_/work_groups/_:id_/worksheet/_:id_

_Request Header_
```
{
    token: "random"
}
```

_Response (200)_
```
{
    id: 1,
    worksheet_id: 1,
    Worksheet: {
        id: 1,
        display_content: json,
        correct_content: json,
        created_at: datetime,
        updated_at: datetime, 
    },
    work_group_id: 1,
        work_group: {
        id: 1,
        name: "group 1",
        video_call_code: "1"
        session_time: 900000,
        turn_time: 3000
        score: 0
        answered: 0
        aasm_state: "on_progress"
        start_at: datetime
        classroom_id: 1
        Classroom: {
            id: 1,
            teacher_id: 1,
        },
        Students_work_groups: [
            {
                id: 1,
                student_id: 1,
                Student: {
                    id: 1,
                    name: "qweqwe"
                },
                work_group_id: 1,
                turn: true,
                joined: true,
                "created_at" datetime
                "updated_at" datetime
            },
            ...
        ],
        "created_at" datetime
        "updated_at" datetime
    },
    created_at: datetime
    updated_at: datetime
}
```

PUT /classrooms/_:id_/work_groups/_:id_/worksheets/_:id_


_Request Header_
```
{
    token: "random"
}
```

_Request Body_
```
{
    display_content: json,
    correct_content: json,
}
```

_Response (200)_

```
    {
        id: 1,
        message: "successfully updated"
    }
```


PUT /classrooms/_:id_/work_groups/_:id_/students/_:id_

_Request Header_
```
{
    token: "random"
}
```

_Request Body_
```
{
    turn: false,
    joined: true,
}
```

_Response (200)_

```
    {
        id: 1,
        message: "successfully updated"
    }
```

