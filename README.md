# Реализация аутентификации при помощи Elixir + Phoenix Framework + Guardian + JWT + Comeonin

## Регистрация

URL: 

http://localhost:8000/api/sign_up

На вход принимает объект следущего вида:

``` json
// POST
// Пароль не менее 6 символов

{
	"user": {
		"login": "login",
		"name": "name",
		"password": "password" 
	}
}
```

На выходе:

``` json
{
    "status": "ok",
    "token": "eyJhbGci....",
    "user": {
        "id": 1,
        "inserted_at": "2021-03-03T16:47:10",
        "login": "login",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$uBF....",
        "updated_at": "2021-03-03T16:47:10"
    }
}
```

## Вход по логину и паролю

URL: 

http://localhost:8000/api/sign_in

На вход принимает объект следущего вида:

``` json
// POST

{
	"user": {
		"login": "login",
		"password": "password"
	}
}
```

На выходе:

``` json
{
    "token": "eyJhbGci....",
    "user": {
        "id": 1,
        "inserted_at": "2021-03-03T16:47:10",
        "login": "login",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$uBF....",
        "updated_at": "2021-03-03T16:47:10"
    }
}
```

## Вход по токену

URL: 

http://localhost:8000/api/sign_in_by_token

На вход принимает объект следущего вида:

``` json
// POST

{
    "token": "eyJhbGci...."
}
```

На выходе:

``` json
{
    "token": "eyJhbGci....",
    "user": {
        "id": 1,
        "inserted_at": "2021-03-03T16:47:10",
        "login": "login",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$uBF....",
        "updated_at": "2021-03-03T16:47:10"
    }
}
```

## Обновление данных (имя и пароль)

URL: 

http://localhost:8000/api/update_user

На вход принимает объект следущего вида:

``` json
// POST
// Необходима авторизация через Bearer токен
// Права на изменение есть только у самого пользователя

{
    "id": 1,
    "password": "password",
    "user": {
        "name": "name1",
        "password": "password1"
    }
}
```

На выходе:

``` json
{
    "status": "ok",
    "user": {
        "id": 1,
        "inserted_at": "2021-03-02T20:20:40",
        "login": "login",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$1iq....",
        "updated_at": "2021-03-03T17:34:43"
    }
}
```

## Удаление пользователя

URL: 

http://localhost:8000/api/delete_user

На вход принимает объект следущего вида:

``` json
// POST
// Необходима авторизация через Bearer токен
// Права на удаление есть только у самого пользователя

{
    "id": 1,
    "password": "password1"
}
```

На выходе:

``` json
{
    "status": "ok",
    "user": {
        "id": 1,
        "inserted_at": "2021-03-02T20:20:40",
        "login": "login",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$1iq....",
        "updated_at": "2021-03-03T17:34:43"
    }
}
```

## Вывод списка пользователей

URL: 

http://localhost:8000/api/users_list

На выходе:

``` json
{
    "users": [
        {            
            "id": 2,
            "inserted_at": "2021-03-03T16:47:10",
            "login": "login2",
            "name": "name",
            "password_hash": "$pbkdf2-sha512$160000$RRv....",
            "updated_at": "2021-03-03T16:47:10"        
        },
        {            
            "id": 3,
            "inserted_at": "2021-03-03T16:57:10",
            "login": "login3",
            "name": "name",
            "password_hash": "$pbkdf2-sha512$160000$ujF....",
            "updated_at": "2021-03-03T16:57:10"        
        }
    ]
}
```

## Получить пользователя по id

URL: 

http://localhost:8000/api/get_user?id=2

*Параметр id принимает id пользователя*

На выходе:

``` json
{
    "user": {
        "id": 2,
        "inserted_at": "2021-03-03T16:47:10",
        "login": "login2",
        "name": "name",
        "password_hash": "$pbkdf2-sha512$160000$RRv....",
        "updated_at": "2021-03-03T16:47:10"            
}
```
