*** Settings ***
Documentation   Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#/Books
Resource        ResourcesAPIBooks.robot
Suite Setup     Conectar a minha API

*** Test Case ***
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir status code    200
    Conferir o reason       OK
    Conferir se retorar uma lista com "200" livros

Buscar um livro específico (GET em um livro específico)
    Requisitar o livro "15"
    Conferir status code    200
    Conferir o reason       OK
    Conferir se retorna todos os dados corretos do livro 15

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir status code    200
    Conferir o reason       OK
    Conferir se retorna todos os dados cadastrados para o novo livro

Alterar um livro (PUT)
    Alterar dados do livro "150"
    Conferir status code    200
    Conferir o reason       OK
    Conferir se retorna todos os dados alterados do livro 150
Deletar um livro (DELETE)
    Apagar o livro "200"
    Conferir se deleta o livro 200 (o response body deve ser vazio)

