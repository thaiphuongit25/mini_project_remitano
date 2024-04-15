# README
* Deployment instructions

* ...
# funny_app
# Run backend
cd backend
```
copy .env.example to .env
```

* Run project at local
```
copy database.yml.example to database.yml
```
- init db
```
  rails db:create
  rails db:migrate
```

- Run unitest
```
  rspec
```

# Run front end
```
copy .env.example to .env
```
- install yarn
```
yarn install
```
- run source
```
yarn run dev
```
- run test
```
yarn run test
```