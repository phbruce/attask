# Attask Ruby Client

This gem is a interface that allows you to make requisitions in the attask. Check it out the [documentation](https://developers.workfront.com/api-docs/).

## Instalation

```ruby
gem install attask
```

```ruby
gem 'attask'
```

## Usage

Configure the data access

```ruby
Attask.configure do |config|
  config.username = ENV['ATTAKS_USERNAME']
  config.password = ENV['ATTAKS_PASSWORD']
end
````

Create a client

```ruby
client = Attask::Client.new('app_name')
```

> The `app_name` basically is the reference to mount the url e.g.: `https://#{app_name}.attask-ondemand.com/api/v6.0`

### Queries

Queries allowed: `eq`, `ne`, `gte`, `lte`, `isnull` and `contains`.

Example of a query using the `between` query

```ruby
object = 'TASK'

query = {
  'plannedCompletionDate'       => '$$TODAY-7',
  'plannedCompletionDate_Range' => '$$TODAY',
  'plannedCompletionDate_Mod'   => 'between'
}

client.search(object, query)
```

### Fields

Retrieving the the field `downloadURL`

```ruby
object = 'DOCU'
fields = ['downloadURL']
client.search('object', { objID: 'xxxxxxxx...' }, fields)
```

### File upload

```ruby
params = {
  name: 'teste.txt',
  description: 'descricao',
  docObjCode: 'TASK',
  objID: 'xxxxxxxx...'
}

client.upload(params, './teste.txt', 'text/plain')
```

### Downloading files

```ruby
# Retrieving a download_url

object = 'DOCU'
fields = ['downloadURL']
files = client.search('object', { objID: 'xxxxxxxx...' }, fields)
download_url = files[0]['downloadURL']

# It's optional
replace_filename = 'example.txt'

client.download(download_url, replace_filename)
```
