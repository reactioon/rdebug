# RDEBUG
RDEBUG is a Watcher Layer (WL) that aim to be lightweight, fast and distributable.

The main goal of this project is a solution to watch apps execution inside of Reactioon services/tools. But rdebug is available to everyone that wants track apps execution on their own project.

## Why build it ?

At Reactioon we have multiples softwares doing specific tasks in each scenario. Most of softwares run in multiples machines, and these machines has multiples providers located in multiples regions. Manager the whole thing sometimes can be a lot difficult, and open margin to problems (connectivity, unexpected running processes, high usage (disk/cpu) and others). We want enhance the quality of our tools, so we search for alternatives to prevent failure, enhance performance and watch whats happening on whole context of reactioon. The solution I like is `NewRelic`, but NewRelic can track somethings and not the code it's self when i'm writing. So, to enhance the quality of our tools we choose create an Watcher Layer called `RDEBUG`.

## How it works ?

RDEBUG is like `NewRelic`, but the focus is the code execution to watch what is happening, test data transfer and track elapsed time running a block of code. So, when the server is starting a tcp/socket connection is open to sent data over network using rdebug-library, the data will be saved o rdebug using `RDATA` internally and an interface http will be created to watch the data recorded with a dashboard on browser. The data has their structure based on spectific flow with multiple types available like `debug`, `logs`, `tests`,  `queries`, `trace` to be called or watched over network.

## Debugger

Our focus is not create an high technical solution to debug, but an watcher layer that can help prevent failure on softwares inside of our ecossystem.

## Requirements

`RDEBUG` is projected to be easy to install and distribute. So, you don't need more than the file inside of `builds` folder.

* 100GB HD
* 4GB RAM
* Linux Debian 11

**Note:** I've tested with Linux Debian, you can check if works fine on other distros.

## Concept

`RDEBUG` has the watcher concept. So, the whole structure of the RDEBUG is based in an specific context with an  typical flow of data for watch like `debug`, `logs`, `tests`, `queries`, `trace`. The context can be the name of app, software, process or anything.

First we have an `Context`, inside of an context we have an `Flow` ( debug | logs | tests | queries | trace ) and inside of an flow we have `Directions` (start | end).

```
[CONTEXT] (App)
[FLOW] (Debug | Logs | Tests | Queries | Trace)
[DIRECTIONS] (Start | End)
```

## Usage

RDEBUG is projected to be easy to install and use. All common flows can be created/recorded with socket connection. The best way to use rdebug after setup the whole thing is with an browser.

To see the webviewer of rdebug you can open the browser on HOST and PORT.
```
http://host:port
```

## Library

RDEBUG has support only to Go lang actually. If you want support in more languages, check out the Go library and create your own library.

## Features

* **Easy to install and distribute**  
Multiple instances of RDEBUG can be created over network to watch data in multiple levels and security.

* **Client / Dashboard**  
Watch the whole data recorded in an dashboard available to any browser.

## Install

The install a rdebug instance is easy, see the full command below:

```sh
./rdebug-server -run-install
```

After execute the command, options will be asked to fill or you can use the default values.

```sh
Welcome to RDEBUG
The installer will start soon...

Location: (default: /reactioon/rdebug)
/reactioon/rdebug

Host: (default: localhost)
192.168.0.1

Port: (default: 8765)
8765

Create an service ? (Y = Yes) (default: No)
Y

The install has been completed.
```

When the installer is working, the folder base will be created and a copy of this file will be saved on desired location. Inside of location a file of settings called `rdebug.yaml` will be created, your can change config inside of it.

**Notes:**

**(1):** If you are running a RDEBUG node with Linux that have `systemctl` installed, you can create the service automatically. This will enable the server start with the command `systemctl start rdebug.service`.  

**(2):** `Location` is where your RDEBUG version will be saved, inside of it has a folder called `rdata.rdt`, inside of this folder you have the whole data created on rdata.

## Server

To start a server run the RDEBUG with `-run-server` flag, see the full command below:

```sh
./rdebug-server -run-server
```

**Note:** When the server is running the instance will be started and open an TCP connection to the host and port, the host and port will be used on library to connect on your rdebug instance.

### Client

To easy explore the whole features of rdebug we build an dashboard web, so you can watch the data (local or remote) using an browser.

```js
http://host:port
```

## Flows

#### `.Debug(context, msg)`
An generic message can be recorded inside of the code, most commonly used when record technical data.

Scope:

```json
{
    "app": "",
    "ref" : "",
    "value": "",
    "line": "",
    "context": "",
    "filename": "",
    "folder": "",
    "timestamp": ""
}
```

**Command call (rdebug-bin):**

```sh
./rdebug -cmd -flow=debug -context=debug -value=10 -app=test -filename=debug.go -line=11 -host=192.168.1.202 -port=8765
```

**Library call (rdebug-go-library):**

```go
rdebug.Debug("app", "Hello world!")
```

#### `.Log(context, topic, msg)`
An context message can be created to store messages that represents an informantion about anything.

Scope:

```json
{
    "app": "",
    "ref" : "",
    "context": "",
    "topic": "",
    "value": "",
    "line": "",
    "filename": "",
    "folder": "",
    "timestamp": ""
}
```

**Command call (rdebug-bin):**
```sh
./rdebug -cmd -flow=log -context=debug -topic="testing logs..." -value="log info" -app=test -filename=debug.go -line=21 -host=192.168.1.202 -port=8765
```

**Library call (rdebug-go-library):**

```go
rdebug.Debug("rdebug", "Updating value of 'abc'...", "def")
```

#### `.Query(type, name)`
Save all communications with database to track elapsed time of each query to enhance performance of an software.

Scope:

```json
{
    "app": "",
    "ref" : "",
    "topic": "",
    "value": "",
    "line": "",
    "context": "",
    "filename": "",
    "folder": "",
    "timestamp": "",
    "elapsed": ""
}
```

**Command call (rdebug-bin):**
```sh
./rdebug -cmd -flow=query -context=debug -name="Query A" -value="SELECT * FROM table" -valuet="SQL" -app=test -filename=debug.go -line=21 -elapsed=2min -host=192.168.1.202 -port=8765
```

**Library call (rdebug-go-library):**

```go
rdebug.Query("SQL","get-users").Start()
rdebug.Query("SQL","get-users").End(context, "SELECT user FROM table WHERE age >= 20 LIMIT 1")
```

#### `.Trace(name)`
Track the execution of an specific block of code to see how much time cost to run.

Scope:
```json
{
    "app": "",
    "topic": "",
    "context": "",
    "value": "",
    "line": "",
    "filename": "",
    "lineend": "",
    "filenameend": "",
    "folder": "",
    "timpestamp": "",
    "elapsed": "",

}
```

**Command call (rdebug-bin):**
```sh
./rdebug -cmd -flow=trace -context=debug -name="Tracing execution" -app=test -filename=debug.go -line=21 -filenameend=debug2.go -lineend=32 -elapsed=1 -host=192.168.1.202 -port=8765
```

**Library call (rdebug-go-library):**
```go
rdebug.Trace("TraceName").Start()
rdebug.Trace("TraceName").End(context)
```

#### `.Test(context, name, expected, received, content)`

Execute integrity tests when the app is running to watch if everything is working fine.

**Scope:**

```json
{
    "app": "",
    "ref": "",
    "context": "",
    "value": "",
    "line": "",
    "filename": "",
    "folder": "",
    "timpestamp": "",
    "name": "",
    "status": "",
    "expected": "",
    "received": "",
    "content": ""
}
```

**Command call (rdebug-bin):**
```
./rdebug -cmd -flow=test -context=debug -name="Test data" -expected="10" -received="20" -app=test -filename=debug.go -line=21 -host=192.168.1.202 -port=8765
```

**Library call (rdebug-go-library):**
```go
rdebug.Test("app", "test-name", "10", "10", "{more_info:true}")
```

## Security

Most of solutions don't need high level of security, in most of cases, they prevent systems using a Firewall. The default install of rdebug enable access to all that have the host:port info, if you want add security on your instance use your firewall to set who will access the host:port of your instance.

## Version

This is a Release Candidate (RC) version, so this tool will be used in the whole ecossystem of Reactioon.

## Performance

RDEBUG is projected to be fast and works with RDATA integrated. So, the tool don't need dependencies and everything is very fast with large amount of data.

At now, when the data is growing too fast, the rdata folder can be too big. So, if you are using with large amount of apps like us on reactioon, you will need more than 50GB in disk space and the performance can be reduced. To prevent it, update your hardware machine to enhance performance.

## Tests

RDEBUG works fine on linux, on future we will do more tests in other environments. But the RC version is in use on reactioon tools, we use it to enhance the quality of our work.

## Use cases

* **Debbuger**  
rdebug can be used to enhance the development of any software.

* **Network monitor**  
rdebug can be used as an monitor to your network. Example: You can Log the usage of cpu, memory.

* **Service stats**  
rdebug can be used to get stats of an service in your machine, like http/mysql/samba.

## License

The usage of RDEBUG is restricted to reactioon users, so the user needs a reactioon account and RTN to use it inside of their project.

The current version of RDEBUG is open and free to test, in the future newest versions will be available only with a license that will be payed with RTN.

## Next steps

* License
* Live Widgets
* Data Export

## Considerations

RDEBUG is in development but the Release Candidate version can be used in development/production, actually the public version is ready to use. If you are looking to enhance the quality of your solutions, RDEBUG can be useful to track important things. 

<br>

That's all! Folks!  
@author José Wilker
