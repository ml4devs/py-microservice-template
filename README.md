# Python Microservice Project Template

Python microservices using FastAPI

## Getting Started

Code is developed using [Python 3.11.1](https://www.python.org/downloads/release/python-3111/) and Visual Studio Code.

Please install [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance) and [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter) VSCode plugins. These plug-ins help catch coding error and apply consistent code formatting respectively.

If you want to have multiple versions of python, you may use tools like [pyenv](https://brain2life.hashnode.dev/how-to-install-pyenv-python-version-manager-on-ubuntu-2004) to manage them.

Creating a Virtual Environment is highly desirable, especially if you are working on multiple Python projects. There are several ways of doing it, but easiest is to install it in the project subtree using `venv`:

```sh
cd /path/to/py-microservice-template
python3 -m venv .venv
source ./.venv/bin/activate
which python  # Verify that it it pointing to .venv/bin/python
python --version # Verify that it is 3.11.1
python -m pip install --upgrade pip
```

If you are using pyenv, you can use it to create virtual environment too:

```sh
pyenv install 3.11.1
pyenv versions
pyenv virtualenv 3.11.1 py-microservice
pyenv versions

cd /path/to/py-microservice-template
pyenv local py-microservice

python --version # Verify that it is 3.11.1
python -m pip install --upgrade pip
```

Install the pip dependencies:

These requirement `.txt` files are built from `requirements/dev.in` and `requirements/base.in` using [`pip-tools`](https://pypi.org/project/pip-tools/):

```sh
python -m pip install pip-tools
make requirements
```

The `base.in` has the packages required while running/deploying ths system, and the `dev.in` has packages required while development and CI/CD (e.g., type checking, testing, code coverage).

The dependencies should always be added in `dev.in` or `base.in` depending upon whether a package is required only for development or also for running the system. Then corresponding `.txt` files should be built using `pip-compile` and checked-in.

For using terminal while development, set `PYTHONPATH` to include the project source and test root dirs.
Project's VSCode setting have this setup already, so you do not need to do this for terminal window within VSCode.

```sh
export PYTHONPATH=/path/to/py-microservice-template/src:/path/to/py-microservice-template/tests
```

## Build and Test

The project is set up with type checking, linting, unit tests, and code coverage. All of these command can be run through [Makefile](Makefile).

You can check that your setup is ready by running:

```sh
make all
```

You can run following separately too:

```sh
make typecheck  # To run MyPy and catch type mistakes
make lint  # To flag code anti-patterns and style issues
make test  # To run unit tests
make coverage  # To run unit tests with code coverage
make clean  # To clean up tmp files
```

Code Coverage results are stored in temporary [htmlcov](./htmlcov/index.html) directory.

Unit tests run in a sandbox and network calls (e.g., to OpenAI) are mocked. The next step is to run smoke test for end-to-end sanity check.

```sh
make smoke
```

The microservices are implemented using [FastAPI](https://fastapi.tiangolo.com/). you can run the server as following:

```sh
cd /path/to/py-microservice-template
uvicorn mypkg.api.main:app --reload --env-file ./.env
```

You can also run it through Makefile command:

```sh
$ make run
...
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [21013] using WatchFiles
INFO:     Started server process [21037]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

FastAPI generates service API documentation automatically from the code. You can check interactive docs at [http://localhost:8000/docs](http://127.0.0.1:8000/docs), or alternative and better looking redoc version [http://local:8000/redoc](http://127.0.0.1:8000/redoc)

You can do a sanity check of the server by running a curl command:

```sh
$ curl -i -X GET http://localhost:8000/info
HTTP/1.1 200 OK
date: Thu, 03 Jul 2025 05:32:26 GMT
server: uvicorn
content-length: 39
content-type: application/json
x-process-time: 0.0007879734039306641

{"name":"Python Microservice Template"}
```

---

&copy; Hyperion Labs
