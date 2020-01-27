module.exports = robot => {

  
  // Listen for a pull request being opened or synchronized
  robot.on('pull_request', async context => {
    // Just assign a variable to make our life easier
    const pr = context.payload.pull_request;
    const repo = context.payload.repository;

    // Get all the commits in the pull request
   const compare = await context.github.repos.compareCommits(context.repo({
      base: pr.base.sha,
      head: pr.head.sha
    }));

    var fullreponame = repo.full_name;
    var pullnum = pr.number;
    var finalurl = 'https://patch-diff.githubusercontent.com/raw/'+fullreponame+'/pull/'+pullnum+'.diff'
        
    console.log(finalurl);
    var text;
    //async'ed for getting scripts
    (async (url) => {
      text = await getScript(url);
      var parse = require('parse-diff');
      var diff = text; // edit this to access the text on the internet site using POST or Get
      var files = parse(diff);

      //This is just a random JSON to jog my memory on how it works
      var data = { 
        hello: [1,2,3,4], 
        there: { 
            a:1, 
            b:2, 
            c:["hello", null]
        } 
    };

      var PRWhole = [];
      var pullRequestJSON = {};
      var Commit = [];
      var hunk=  {};
      var changeline = [];
      var chunkcount = 0;
      var changecount = 0;
    console.log("TEsting The JSON here");
    console.log(data.hello);
    console.log("TEsting The JSON here");

      //console.log(files.length); // number of patched files
      console.log(files[1].index[0].slice(9,16)); //This cuts the ID of the commmit 
      
      files.forEach(function(file) {
        chunkcount = 0;
      //console.log(file.chunks[0].changes);
      file.chunks.forEach(function(chunk){
        
        chunk.changes.forEach(function(change){
          //console.log(change);
          if(change.type == 'add')
          {
            changeline.push(change.content);
            //Create a JSON OBJ here that takes in all the addition 
          }
        });
      
        hunk = {
          "chunknum":chunkcount,
          "edit": changeline
        };
        Commit.push(hunk);
        chunkcount = chunkcount+1;
        changeline =[];
      });
      pullRequestJSON = { 
        "commitID":file.index[0].slice(9,16),
        "commitData":Commit
      }
      PRWhole.push(pullRequestJSON);      
      
  });
  console.log(JSON.stringify(PRWhole[0].commitData));
  })(finalurl);

  const { exec } = require("child_process");
  //move this up top later with predefined var's 
  var val = "ping www.google.com";
  
  exec(val, (error, stdout, stderr) => {
      if (error) {
          console.log(`error: ${error.message}`);
          return;
      }
      if (stderr) {
          console.log(`stderr: ${stderr}`);
          return;
      }
      console.log(`stdout: ${stdout}`);
  });
    
  });
};
//This is the script for URL
const getScript = (url) => {
  return new Promise((resolve, reject) => {
      const http      = require('http'),
            https     = require('https');

      let client = http;

      if (url.toString().indexOf("https") === 0) {
          client = https;
      }

      client.get(url, (resp) => {
          let data = '';

          // A chunk of data has been recieved.
          resp.on('data', (chunk) => {
              data += chunk;
          });

          // The whole response has been received. Print out the result.
          resp.on('end', () => {
              resolve(data);
          });

      }).on("error", (err) => {
          reject(err);
      });
  });
};