skulder-api
===========
[![Build Status](https://travis-ci.org/gish/skulder-api.svg)](https://travis-ci.org/gish/skulder-api)

Project for testing creating a REST API using RoR

## Authentication
All requests must be authenticated by an API key and a user secret. In the event the authentication fails, the call will return `401 Unauthorized`.

```bash
curl -H /v1/users/?api_key=API-KEY&user_secret=USER-SECRET
```

## Users
### List all users
```bash
GET /users
```

#### Response
```
[{
    "uuid": "1f68dc08-4f0a-47b9-b253-260e3af00377",
    "email": "john@doe.com",
    "given_name": "John",
    "last_name": "Doe",
    "created_at": "2015-01-01T18:05:36.309Z",
    "updated_at": "2015-01-01T18:32:30.442Z"
}, {
    "uuid": "9dd968f5-9f7f-494f-a38c-8dfb219c1ec0",
    "email": "jane@doe.com",
    "given_name": "Jane",
    "last_name": "Doe",
    "created_at": "2015-01-04T07:35:46.621Z",
    "updated_at": "2015-01-04T07:35:46.621Z"
}]
```

### Get a specific user
```
GET /users/:id
```

#### Response
```
{
    "uuid": "9dd968f5-9f7f-494f-a38c-8dfb219c1ec0",
    "email": "jane@doe.com",
    "given_name": "Jane",
    "last_name": "Doe",
    "created_at": "2015-01-04T07:35:46.621Z",
    "updated_at": "2015-01-04T07:35:46.621Z"
}
```

### Get the user's friends
A user's friends are users that have received or sent a transaction to the user
```
GET /users/:id/friends
```

#### Response
```
[{
    "id": "9dd968f5-9f7f-494f-a38c-8dfb219c1ec0",
    "email": "john@doe.com",
    "given_name": "John",
    "last_name": "Doe",
    "created_at": "2015-01-04T07:35:46.621Z",
    "updated_at": "2015-01-04T07:35:46.621Z"
,
    "id": "2ca44021-d194-41b2-95a9-cabe29384b43",
    "email": "bob@doe.com",
    "given_name": "Bob",
    "last_name": "Doe",
    "created_at": "2015-01-04T07:35:46.621Z",
    "updated_at": "2015-01-04T07:35:46.621Z"
}]

```
### Create a user
```
POST /users/
```

#### Parameters
Name | Type | Description
---- | ---- | -----------
email | string | E-mail address **required**
given_name | string | Given name **required**
last_name | string | Last name **required**

#### Response
Status: `201 Created`

Location: `/users/029e3bd0-ddb1-4ba5-ad6d-4d4feaec1a08`

## Transactions

### List transactions
List transactions with a specific receiving user and/or sending user.

```
GET /transactions/?recipient=USER-ID&sender=USER-ID
```
#### Parameters
At least one of *recipient* or *sender* must be present.

name | type | description
-------|-------|--------------
recipient | integer | id of the receiving user **optional**
sender | integer | id of the sending user **optional**


#### Response
Body:
```
[{
    "uuid": "11dc7a30-d651-4888-8726-3aba9eb8f455",
    "recipient_id": "7d835c59-db59-4e4f-acea-f4185e6debd5",
    "sender_id": "1f68dc08-4f0a-47b9-b253-260e3af00377",
    "balance": 4200,
    "description": "An octopus",
    "created_at": "2015-02-08T13:42:31.990Z",
    "updated_at": "2015-02-08T13:42:31.990Z"
}]
```

### Get a specific transaction
Not implemented

### Create a transaction
```
POST /transactions/
```

#### Parameters
name | type | description
-------|-------|--------------
recipient | integer | id of the receiving user **required**
sender | integer | id of the sending user **required**
balance | integer | amount transfered between sender and recipient in cents **required**
description | string | description of the transaction **required**

#### Response
Status: `201 Created`

Location: `/transactions/029e3bd0-ddb1-4ba5-ad6d-4d4feaec1a08`
