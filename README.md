# Attask

A classe Attask::Client é a interface HTTP da Attask onde é possível fazer as requisições encontradas na [https://developers.workfront.com/api-docs/#Actions](documentação).

## Como usar

Configure os dados de acesso

```ruby
# Exemplo:
Attask.configure do |config|
  config.username = ENV['ATTASK_USERNAME']
  config.password = ENV['ATTASK_PASSWORD']
end
```

### Queries

**Queries aceitas:** `eq`, `ne`, `gte`, `lte`, `isnull`, `notnull` e `contains`.

Exemplo de uma query usando between:

```ruby
require_relative 'lib/attask/client.rb'

# Setando o objeto que quero` buscar
object = 'TASK'

# Montando a query
query = {
  'plannedCompletionDate'       => '$$TODAY-7',
  'plannedCompletionDate_Range' => '$$TODAY',
  'plannedCompletionDate_Mod'   => 'between'
}

client = Attask::Client.new({ timeout: 120 })
client.search(object, query)
```

### Fields

Para cada Objeto, existem uma quantidade de campos (`fields`) que você pode obter a partir dele em seu retorno. Para saber os campos que cada objeto, entre neste [https://developers.workfront.com/api-docs/api-explorer/](link). Lembrando que atualmente utilizamos a versão 6.0 da API da attask.

Exemplo utilizando o objeto `DOCU`, solicitando o campo `downloadURL`:

```ruby
require_relative 'lib/attask/client.rb'
# Setando o objeto que quero buscar
object = 'DOCU'

# definindo os campos que eu quero que retorne
fields = ['downloadURL']

client = Attask::Client.new({ timeout: 120 })
client.search(object, { '$$LIMIT' => 2000 }, fields)
```

## Upload de arquivos

```ruby
require_relative 'lib/attask/client.rb'
client = Attask::Client.new

filename = 'teste.txt'
description = 'descricao'
object_code = 'TASK'
object_id = '586ab38f001b36bfbb586053760aec3d'

# Crie um handle
handle = client.handle("./#{filename}", 'text/plain')

# Com o handle em mãos, faca a requisição para envio de um documento

params = {
  description: description,
  docObjCode: object_code,
  objID: object_id,
  handle: handle,
  name: filename
}.to_json

client.upload(params)
```
