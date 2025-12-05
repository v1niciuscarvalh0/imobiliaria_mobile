# 🏠 App de Gerenciamento de Imóveis e Clientes

Aplicativo Flutter para gerenciar imóveis e clientes, integrado a uma API RESTful. Permite listar, cadastrar, editar e excluir registros, com suporte a paginação, busca, validações e feedback de carregamento.

## Tecnologias

- Flutter / Dart  
- Dio para requisições HTTP  
- API RESTful (Java / Spring Boot)  
- Banco de dados relacional (MySQL / PostgreSQL)  
- JSON para troca de dados  

## Funcionalidades

- **Clientes:** listagem paginada, busca por nome, adicionar, editar e excluir, validação de formulário, feedback de carregamento.  
- **Imóveis:** listagem paginada, busca por descrição, adicionar, editar e excluir, validação de formulário, feedback de carregamento.  

## Modelos e Campos

### Cliente
- `id`: bigint, auto-increment, não obrigatório  
- `nome`: string, obrigatório  
- `email`: string, obrigatório e único  
- `telefone`: string, obrigatório  
- `endereco`: string, opcional  
- `cpf`: string, obrigatório e único  
- `login`: string, obrigatório e único  
- `senha`: string, obrigatório  
- `dataNascimento`: date, opcional, formato `YYYY-MM-DD`  

### Imóvel
- `id`: bigint, auto-increment, não obrigatório  
- `titulo`: string, obrigatório  
- `descricao`: string, obrigatório  
- `rua`: string, obrigatório  
- `numero`: string, opcional  
- `complemento`: string, opcional  
- `bairro`: string, opcional  
- `cidade`: string, opcional  
- `estado`: string, opcional  
- `cep`: string, opcional  
- `preco`: double, obrigatório  
- `proprietarioId`: int, obrigatório, deve existir como Cliente  

## Como rodar

Para rodar o aplicativo, primeiro instale o Flutter seguindo a documentação oficial. Em seguida, clone o projeto e navegue até a pasta do app. Depois disso, rode `flutter pub get` para instalar todas as dependências.

No arquivo `lib/core/network/api_client.dart`, configure o `baseUrl` para o endereço do servidor da API. Por exemplo, se estiver rodando localmente em um emulador Android, use `http://10.0.2.2:8080/api`. Se estiver em outro dispositivo ou servidor, substitua pelo IP ou URL correspondente.

Após isso, rode `flutter run` para iniciar o aplicativo no seu dispositivo ou emulador.

## Observações

- Campos obrigatórios devem ser preenchidos para evitar erro 400 da API.  
- Paginação, debounce na busca e feedback de carregamento foram implementados.  
- Campos opcionais (`dataNascimento`, `endereco`, `numero`, `complemento`, `bairro`) podem ser deixados em branco.  
- A aplicação já lida com feedback visual, mostrando ícones de loading durante operações assíncronas.
