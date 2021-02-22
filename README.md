# Teddy: Automatic Recommendation of Pythonic Idiom Usage For Pull-Based Software Projects
A repo for the Teddy tool. 

## Required Components
- Elasticsearch **2.2.0**
- Apache Maven 3.6.3 or higher

## Setting up Elasticsearch 2.2.0 and restore the python-patterns index
1. In `~/elasticsearch-2.2.0-teddyplus/config/elasticsearch.yml`, specify the absolute path to the snapshot folder as follow 
`path.repo: <REPO_FOLDER>/elasticsearch-2.2.0-teddyplus/snapshot/backups`
2. Save the config file and launch the Elastic server (`.~/elasticsearch-2.2.0-teddyplus/bin/elasticsearch`)
3. Bind the snapshot folder to the running Elastic via API: 
`curl -XPUT localhost:9200/_snapshot/backups?pretty' -d '{"type":"fs","settings":{"location":"<SAME_PATH_AS_path.repo>"},"compress":true}}'`
4. Restore the snapshot of __python-patterns__ index to the running Elastic using API: 
`curl -XPOST 'localhost:9200/_snapshot/backups/snapshot_1/_restore?pretty'`
5. (Optional) Check that the __python-patterns__ index has been restored in the Elastic using API: 
`curl -XGET 'localhost:9200/_cat/indices?pretty'`

## Setting up Teddy
1. Use `git clone` to make a local copy of this branch on your machine, or download this branch as a `.zip` package and extract it.

2. From `.\config\elasticsearch.yml` file in the Elasticsearch folder, check the value of the parameter `cluster.name`, then set the value of the property `cluster` inside `.\webapp\config.properties` in SP2019-TEDDY folder to be the same name.

3. In `config.properties` file, be sure to set the value of property `index` to be the name of an existing index in your local Elasticsearch. (To see the list of index in your Elasticsearch, go to `localhost:9200/_cat/indices?v=pretty` on a web browser).

4. Using another `cmd` or PowerShell instance, go to `.\webbapp` directory of SP2019-TEDDY folder

5. Use the command `mvn spring-boot:run` to launch Spring-boot framework and run TEDDY

6. On any web browser, go to `localhost:8080/search` to start using TEDDY (Google Chrome is recommended).

## PREVENTION MODE USER INSTALLATION

** DON - Please work on this part **

## DETECTION MODE USER INSTRUCTION (directly via Linux terminal)

**WARNING: These steps have only been tested on Linux **

**DO NOT REMOVE ANY OF THE FILES IN THIS FOLDER**

0. Needed dependencies and library before start using:
	- Java JDK 1.8 or above
	- Python 3.X.X
	- `pandas` library for Python
	- `bokeh` library for Python
	- `git` bash for Linux
1. Open a terminal and turn on Elasticsearch server (`./elasticsearch`) at `~/elasticsearch-2.2.0-linux/bin`
2. Make sure there is no any folder located in the directory `~/detection-mode/`
3. Open another terminal and execute `AutoRun.sh` at `~/detection-mode/` with the following order of arguments:
	- `.git` URL of a GitHub repository
	- directory for the result CSV files from Siamese to be saved, NOT within THE REPO (absolute path recommended)
	- name for the Elasticsearch index of the repo (no whitespace allowed)
	- **Example: `$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask`**
4. (Optional) You can also specify the interval of commits using `-a` and `-b`.
	- **Example: If you would like to collect the commits after `2011/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -a "2011/01/01"`
	- **Example: If you would like to collect the commits before `2011/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -b "2011/01/01"`
	- **Example: If you would like to collect the commits between `2011/01/01` and `2020/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -a "2011/01/01" -b "2020/01/01"`
	**If Teddy-plus cannot get any commits, it shows that message, then please check your specified format is correct or not. : `There is no commits.`**
5. Finally, a file named `myplot.html` will be created here. This is the final visualization of detection mode. Move it to wherever you like. Use a web browswer (Google Chrome is recommended) to view the file.
6. NOTE: Detection mode takes a considerable amount of time to complete depending on the repository's size and number of commits present.

