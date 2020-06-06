*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Variable ***
${URL_API}      https://fakerestapi.azurewebsites.net/api/
&{BOOK_15}      ID=15
...             Title=Book 15
...             PageCount=1500

&{NEW_BOOK}     ID=9999
...             Title=Book 9999
...             Description=Book para testadores
...             PageCount=260
...             Excerpt=Teste
...             PublishDate=2020-05-24T18:14:39.210Z

&{BOOK_150}    ID=150
...            Title=Book 150 - Alterado
...            Description=Lorem lorem lorem
...            PageCount=1500
...            Excerpt=Alterado
...            PublishDate=2019-12-26T20:21:06.4594505+00:00

*** Keywords ***
#Setup e TearDowns
Conectar a minha API
    Create Session      fakeAPI     ${URL_API}
    ${HEADERS}      Create Dictionary      content-type=application/json 
    Set Suite Variable    ${HEADERS}

#Testes
Requisitar todos os livros
    ${RESPOSTA}     Get Request     fakeAPI     Books
    Log             ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Requisitar o livro "${ID_Books}"
    ${RESPOSTA}     Get Request     fakeAPI     Books/${ID_Books}
    Log             ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Cadastrar um novo livro  
    ${RESPOSTA}     Post Request     fakeAPI     Books
    ...                              data=${NEW_BOOK}
    ...                              headers=${HEADERS}
    Log             ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Alterar dados do livro "${ID_Books_PUT}"
    ${RESPOSTA}     Put Request     fakeAPI     Books/${ID_Books_PUT}
    ...                              data=${BOOK_150}
    ...                              headers=${HEADERS}
    Log             ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Apagar o livro "${ID_Books_DELETE}"
    ${RESPOSTA}     Delete Request     fakeAPI     Books/${ID_Books_DELETE}
    Log             ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}


#Conferencias ou Verificações dos testes
Conferir status code
    [Arguments]     ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings      ${RESPOSTA.status_code}     ${STATUSCODE_DESEJADO}

Conferir o reason
    [Arguments]     ${REASON_DESEJADO}
    Should Be Equal As Strings      ${RESPOSTA.reason}     ${REASON_DESEJADO}

Conferir se retorar uma lista com "${QTDE_LIVROS}" livros
    Length Should Be    ${RESPOSTA.json()}      ${QTDE_LIVROS}

Conferir se retorna todos os dados corretos do livro 15    
    Dictionary Should Contain Item    ${RESPOSTA.json()}    ID              ${BOOK_15.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Title           ${BOOK_15.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount       ${BOOK_15.PageCount}
    Should Not Be Empty               ${RESPOSTA.json()["Description"]}
    Should Not Be Empty               ${RESPOSTA.json()["Excerpt"]}
    Should Not Be Empty               ${RESPOSTA.json()["PublishDate"]}

Conferir se retorna todos os dados cadastrados para o novo livro    
    Dictionary Should Contain Item    ${RESPOSTA.json()}    ID              ${NEW_BOOK.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Title           ${NEW_BOOK.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount       ${NEW_BOOK.PageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Description     ${NEW_BOOK.Description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Excerpt         ${NEW_BOOK.Excerpt}
    Should Not Be Empty               ${RESPOSTA.json()["PublishDate"]}

Conferir se retorna todos os dados alterados do livro 150
    Dictionary Should Contain Item    ${RESPOSTA.json()}    ID              ${BOOK_150.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Title           ${BOOK_150.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount       ${BOOK_150.PageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Description     ${BOOK_150.Description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Excerpt         ${BOOK_150.Excerpt}
    Should Not Be Empty               ${RESPOSTA.json()["PublishDate"]}

Conferir se deleta o livro 200 (o response body deve ser vazio)   
    Should Be Empty    ${RESPOSTA.content}