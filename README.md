# Teddy: Automatic Recommendation of Pythonic Idiom Usage For Pull-Based Software Projects
A repo for the Teddy tool. 

## Required Components
- Elasticsearch **2.2.0**
- Apache Maven 3.6.3 or higher
- Java 8.x.x

## Setting up Elasticsearch 2.2.0 and restore the python-patterns index
1. In `~/elasticsearch-2.2.0-teddyplus/config/elasticsearch.yml`, specify the absolute path to the snapshot folder as follow 
`path.repo: <CLONED_REPO_FOLDER>/elasticsearch-2.2.0-teddyplus/snapshot/backups`
2. Save the config file and launch the Elastic server (`.~/elasticsearch-2.2.0-teddyplus/bin/elasticsearch`)
3. Bind the snapshot folder to the running Elastic via API: 
`curl -XPUT 'localhost:9200/_snapshot/backups?pretty' -d '{"type":"fs","settings":{"location":"<SAME_PATH_AS_path.repo>"},"compress":true}}'`
4. Restore the snapshot of __python-patterns__ index to the running Elastic using API: 
`curl -XPOST 'localhost:9200/_snapshot/backups/snapshot_1/_restore?pretty'`
5. (Optional) Check that the __python-patterns__ index has been restored in the Elastic using API: 
`curl -XGET 'localhost:9200/_cat/indices?pretty'`

## DETECTION MODE USER INSTRUCTION (directly via Linux terminal)
0. Needed dependencies and library before start using:
	- Java JDK 1.8.X
	- Python 3.X.X
	- `pandas` library for Python
	- `bokeh` library for Python
	- `git` bash for Linux
1. Make sure that your local Elasticsearch is running and has the __python-patterns__ index inside (refer to __Setting up Elasticsearch 2.2.0 and restore the python-patterns index__ in the above section)
2. Make sure there is no any folder located in the directory `~/detection-mode/`
3. Open another terminal and execute `AutoRun.sh` at `~/detection-mode/` with the following order of arguments:
	- `.git` URL of a GitHub repository
	- directory for the result CSV files generated by Siamese Engine to be saved, NOT within THE REPO (absolute path recommended)
	- Name of the repository you are analyzing (no whitespace allowed)
	- **Example: `$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask`**
4. (Optional) You can also specify the interval of commits using `-a` and `-b`.
	- **Example: If you would like to collect the commits after `2011/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -a "2011/01/01"`
	- **Example: If you would like to collect the commits before `2011/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -b "2011/01/01"`
	- **Example: If you would like to collect the commits between `2011/01/01` and `2020/01/01`:**
		`$ ./AutoRun https://github.com/pallets/flask.git /home/flask-results flask -a "2011/01/01" -b "2020/01/01"`
	**If Teddy-plus cannot get any commits, it shows that message, then please check your specified format is correct or not. : `There is no commits.`**
5. Finally, a file named `myplot.html` will be in the same folder as Siamese's output CSV folder. This is the final visualization of detection mode. Move it to wherever you like. Use a web browswer (Google Chrome is recommended) to view the file.
6. NOTE: Detection mode takes a considerable amount of time to complete depending on the repository's size and number of commits present.
