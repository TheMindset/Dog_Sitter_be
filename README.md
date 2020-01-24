# Dog Sitter

#### The front-end part is still under development. 

## About

Some dog lovers don't have the time or money to have a full-time dog. Others want to keep their dog for an afternoon, a day, or a week without paying a huge amount of money or asking busy friends. DogSitter takes care of connecting each others. You can view the profile of a dog and its owner or search by type of dog (age, weight, distance to you). When you find the ideal dog you can contact its owner.

### Technique Stack

* Ruby on Rails / PostgreSQL

* GraphQL API

* AWS S3 (photo storage)

* CircleCI/CD

* Testing (Rspec, Capybara, VCR, Webmock)

* React / Router / Redux / Apollo GraphQL

## Endpoints

This service utilizes [GraphQL](https://graphql.org/). All queries are made to a single endpoint, `POST / graphql`. This endpoint return 200 (OK). If there is an error, it will be present in an `errors` atribute of the response, and the data attribute will be `null`.

### /graphql?query={users{id,firstName,email}}

Returns a list of all users. Additional attributes should be included as comma separated values without any spacing.
Available attributes for _users_ are:

* id - ID
* lastName - String
* firstName - String
* email - String
* longDesc - String
* shortDesc - String
* dogs - [DogType]
* location [LocationType]

#### Example of expected output:

<details>

```json
{
    "data": {
        "users": [
            {
                "id": "1",
                "firstName": "Sharen",
                "email": "taylor@jacobi.biz"
            },
            {
                "id": "2",
                "firstName": "Troy",
                "email": "ozell_schmidt@wunschtoy.info"
            },
            {
                "id": "3",
                "firstName": "Vito",
                "email": "deneen@dibbert.biz"
            },
            {
                "id": "4",
                "firstName": "Jermaine",
                "email": "kacey@kunde.name"
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
* email - String
* activityLevel - Int
* longDesc - String
* shortDesc - String
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
* zipcode - String
* state - String
* lat - Float
* long - Float

id
streetAddress
city
zipCode
state
lat
long

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

