/*

 getPath.cpp
 Kelly Itakura

 Removes overlap top down and prints out the results up to maxres.

*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <sstream>

using namespace std;

vector<string> tokenizer(string str, string delims);
string itoa(const unsigned int a);


int main(int argc, char *argv[]){

string line, query, qid;
vector<string> sv;
vector<string>::iterator it;
int skipFlag=0;
map<unsigned int, vector<unsigned int> > checked;
map<unsigned int,unsigned int> endTag;
map<unsigned int,unsigned  int>::iterator mit;
ifstream in, mapFile;
ofstream out;
int count=0, skip=0, prevTopic=-1;
int numres=150;

if(argc==2) numres=atoi(argv[1]);
        


out.open("results.txt");
in.open("scoredTopics.txt.s");
if(in.is_open()){
	while(getline(in,line)){
                sv=tokenizer(line," ");
		if(atoi(sv[0].c_str())!=prevTopic){
			//Perge queries.
			if(prevTopic!=-1){
				//A dummy query to record the topic ID, because @get query cannot specify query id's.
				cout<<"@okapi[id="<<prevTopic<<"][count=1] \"<sitename>\"..\"</sitename>\" by \"wikipedia\""<<endl; 
				cout<<query;
				query="";
			}
			prevTopic=atoi(sv[0].c_str());
			count=0;
			endTag.clear();
			checked.clear();
			skip=0;
		}
		if(atof(sv[1].c_str())==0 || skip){
			continue;
		}
                unsigned int sec=atoi(sv[2].c_str()), third=atoi(sv[3].c_str());
                unsigned int f=atoi(sv[4].c_str());

                for(int i=0; i<checked[f].size(); i++){
			if(checked[f][i]<=sec && sec<=endTag[checked[f][i]]){
                                skipFlag=1;
                                break;
                        }
			if(sec<=checked[f][i] && checked[f][i]<=third){
                                skipFlag=1;
                                break;
                        }
                }
                if(skipFlag){
                        skipFlag=0;
                        continue;
                }
                endTag[sec]=third;
                checked[f].push_back(sec);

		count++;
		if(count>=numres){
			skip=1;
		}
		query+="@get ";
		query+=itoa(sec); 
		query+=" ";
		query+=itoa(third);
		query+="\n";

	}// end while getline
	//To flush the last stuff.
	//A dummy query to record the topic ID, because @get query cannot specify query id's.
	cout<<"@okapi[id="<<prevTopic<<"][count=1] \"<sitename>\"..\"</sitename>\" by \"wikipedia\""<<endl; 
	cout<<query;
	
	in.close();
	out.close();
} //end if open
else{
	cout<<"Failed to open scoredTopics.txt.s"<<endl;
	exit(1);
}

}

// tokenizer code taken from dimkadimon's comments at http://forums.topcoder.com/?module=Thread&threadID=155285&start=0&mc=16
vector<string> tokenizer(string str, string delims)
{
        vector<string> tokens;
        int pos, pos2;
        pos = str.find_first_not_of(delims, 0);

        while (pos >= 0)
        {
                pos2 = str.find_first_of(delims, pos);
                if (pos2 < 0) pos2 = str.length();
                tokens.push_back(str.substr(pos, pos2-pos));
                pos = str.find_first_not_of(delims, pos2);
        }
        return tokens;
}

string itoa(const unsigned int a){

	stringstream s1;
	string s2;
	s1<<a;
	s1>>s2;
	return s2;
}
