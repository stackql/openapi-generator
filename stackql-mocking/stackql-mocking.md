

```bash

docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate     -i /local/sandbox/github/v0.3.0/api.github.com.2022-11-28.deref.json   --reserved-words-mappings '-1=minus1'  -g go-server     -o /local/out/go-srv-gh-all
```

```bash

docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate     -i /local/sandbox/github/v0.3.0/api.github.com.2022-11-28.deref.json  -g python-flask     -o /local/out/github-all-flask


```

Adapted From examples:

```
docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i /local/modules/openapi-generator/src/test/resources/3_0/petstore.yaml \
    -g go \
    -o /local/out/go

docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i /local/modules/openapi-generator/src/test/resources/3_0/petstore.yaml \
    -g python-flask \
    -o /local/out/python-flask
```

## Applying for stackql

Plan:

- Build a bunch of docker images.
- Run on docker with different host ports using `-p <host port>:<container port>` pattern where container port is generally `8080` by default.

This actually works for super simple stubbing, using the `stackql` `github.users` service:

```bash
docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate     -i /local/sandbox/github/v3.1/services/users.yaml     -g python-flask     -o /local/out/gh-user-python-flask

stackql-mocking/run-in-op-dir.sh out/gh-user-python-flask docker build -t openapi_server .

stackql-mocking/run-in-op-dir.sh out/gh-user-python-flask docker run -p 8080:8080 openapi_server

# and then the diagnostic session reveals very basic stubbs are present...
$ curl http://localhost:8080/user
"do some magic!"
$ curl http://localhost:8080/userz
{
  "detail": "The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.",
  "status": 404,
  "title": "Not Found",
  "type": "about:blank"
}
```

### Best example yet

This actually works for super simple stubbing, using the `stackql` `github.orgs` service:

```bash
stackql-mocking/docker-generate.sh sandbox/github/v3.1/services/orgs.yaml python-flask  gh-orgs-python-flask

stackql-mocking/run-in-op-dir.sh out/gh-orgs-python-flask docker build -t gh_orgs_openapi_server .

stackql-mocking/run-in-op-dir.sh out/gh-user-python-flask docker run -p 8090:8080 gh_orgs_openapi_server

# and then the diagnostic session reveals very basic stubbs are present...
$ curl http://localhost:8090/org
{
  "detail": "The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.",
  "status": 404,
  "title": "Not Found",
  "type": "about:blank"
}
$ curl http://localhost:8090/organizations
"do some magic!"

```

