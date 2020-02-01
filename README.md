# Dog Sitter

## About

Some dog lovers don't have the time or money to have a full-time dog. Others want to keep their dog for an afternoon, a day, or a week without paying a huge amount of money or asking busy friends. DogSitter takes care of connecting each others. You can view the profile of a dog and its owner or search by type of dog (age, weight, distance to you). When you find the ideal dog you can contact its owner.

### Technique Stack

* Ruby on Rails / PostgreSQL

* GraphQL API

* AWS S3 (photo storage)

* CircleCI/CD

* Testing (Rspec, Capybara, VCR, Webmock, Jest, Snapshot)

* React / Router / Redux / Redux-thunk / Apollo GraphQL

### Feature in development

#### GraphQL API
  * createPhoto mutation. **User Sotry**: The dog(s) owner can add/delete pictures of his dog. The picture must be save on AWS S3.

  * Implement [chatkit](https://pusher.com/chatkit). **User Sotry** : A user logged can start can start a discussion with the dog's owner if he is online or leave him a message. The message will also be sent by email.

#### The front app (React)
  * Implement React on the ROR GraphQL API.
  * Build the front app with Apollo GraphQL, Redux / Redux-thunk / Router

### Upcoming Feature

#### Calendar Microservice (NodeJs/ Express/ (GraphQL or REST))
  * **User Story**: The dog(s) owner can add on a calendar the date when they will be absent. In this way, the users can directly reserve the slot and wait confirmation from the owner of the dog(s).


## Endpoints

This service utilizes [GraphQL](https://graphql.org/). All queries are made to a single endpoint, `POST / graphql`. This endpoint return 200 (OK). If there is an error, it will be present in an `errors` atribute of the response, and the data attribute will be `null`.

### /graphql?query={users{id,firstName}}

Returns a list of all users. Additional attributes should be included as comma separated values without any spacing.
Available attributes for _users_ are:

* id - ID
* firstName - String
* longDesc - String
* shortDesc - String
* distance -Float (in km, null if the current user or queried user does not have a location defined)
* dogs - [DogType]

#### Example of expected output:

<details>

```json
{
    "data": {
        "users": [
            {
                "id": "1",
                "firstName": "Sharen",
            },
            {
                "id": "2",
                "firstName": "Troy",
            },
            {
                "id": "3",
                "firstName": "Vito",
            },
            {
                "id": "4",
                "firstName": "Jermaine",
            }
        ]
    }
}

```
</details>

---

### /graphql?query={dogs{id,name,breed}}

Returns a list of all dogs. Additional attributes should be included as comma separated values without any spacing.
Available attributes for _dogs_ are:

* id - ID
* name - String
* age - Int
* breed - String
* activityLevel - Int
* longDesc - String
* shortDesc - String
* distance -Float (in km, null if the current user or queried doq's user does not have a location defined)
* user - UserType
* location - LocationType


#### Example of expected output:

<details>

```json
{
    "data": {
        "dogs": [
            {
                "id": "1",
                "name": "Seurat",
                "breed": "Newfoundland"
            },
            {
                "id": "2",
                "name": "Diego Rivera",
                "breed": "Bull Mastiff"
            },
            {
                "id": "3",
                "name": "Ansel Adams",
                "breed": "Fox Terrier"
            }
        ]
    }
}

```
</details>

---

### /graphql?query={locations{id,streetAddress,city}}

Returns a list of all locations. Additional attributes should be included as comma separated values without any spacing.
Available attributes for _locations_ are:

* id - ID
* streetAddress - String
* city - String
* zipCode - String
* state - String
* lat - Float
* long - Float

#### Example of expected output:

<details>

```json
{
  "data": {
    "locations": [
      {
        "id": "1",
        "streetAddress": "561 Osvaldo Rapid",
        "city": "Lake Justina"
      },
      {
        "id": "2",
        "streetAddress": "2259 Turcotte Way",
        "city": "South Ronnie"
      },
      {
        "id": "3",
        "streetAddress": "4493 Ngan Walks",
        "city": "Raynorland"
      },
      {
        "id": "4",
        "streetAddress": "81482 Donald Place",
        "city": "Karrenbury"
      }
    ]
  }
}
```
</details>

---

### /graphql?query={currentUser{lastName,email,distance,dogs{name},location{city}}}&google_token=GOOGLE_TOKEN

Returns an authenticated user, based on the specified google_token. Returns nil if no user has the specified google_token.
After authentification available attributes for _currentUser_ are: 

* id - ID
* firstName - String
* lastName - String
* email - String
* longDesc - String
* shortDesc - String
* distance -Float (in km, null if the current user or queried user does not have a location defined)
* dogs - [DogType]
* location - [LocationType]

---

### /graphql?query={dogs(ageRange:[1,3],weightRange:[10,20]){name,shortDesc}}

Returns a list of dogs, with the options to filter. If the the request are made by the currentUser, the dogs are sorted by distance from him.
Available filters for _dogs_ are:

* ageRange: [Int]
* weigthRange: [Int]
* breed: [String]
* activityLevel: [Int]

#### Example of expected output:

<details>

```json
{
  "data": {
    "dogs": [
      {
        "name": "Ansel Adams",
        "shortDesc": "When Chuck Norris points to null, null quakes in fear."
      },
      {
        "name": "Degas",
        "shortDesc": "Chuck Norris does not use revision control software. None of his code has ever needed revision."
      }
    ]
  }
}
```
</details>

---


## Get Started

### Requirements

* [Ruby 2.6.3](https://www.ruby-lang.org/en/downloads/) - Ruby Version
* [Rails 5.2.3](https://rubyonrails.org/) - Rails Version

```shell
$ git@github.com:TheMindset/Dog_Sitter_be.git
$ cd Dog_Sitter_be
$ bundle install
```

### Setup Database

* Install [PostgresQL](https://www.postgresql.org/download/)
Run this commands:

```shell
$ rails db:create db:migrate db:seed
```

### API Exploration

Once installation and database setup are complete, explore the various API endpoints with the following steps:
* `$ rails s`
* Open your browser, and visit `http://localhost:3000/`
* In a separate terminal window, query the available endpoints by running `rails routes`
* Copy any of the URIs displayed and append to `http://localhost:3000/` in your browser.
* You can also utilize the graphical tool from this URL `http://localhost:3000/graphiql`

### Running Tests

`$ rails rspec`.

