/**
 getScores.cpp
 Kelly Itakura

 Given a list of passages, computes the okapi scores.

       Ignores passages whose length is <25, or whose
       score is 0. Nesting elimination is performed in getPath.cpp.
*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

const int maxTerm=50; 
const int topicSize=850;

vector<string> tokenizer(string str, string delims);

int main(int argc, char *argv[]){

double k=1.6, b=0.2, avg=100;
	if(argc==4){
		k=atof(argv[1]);
		b=atof(argv[2]);
		avg=atof(argv[3]);
	}

double A=k+1;
double B=1-b;
double C=0; // is a function of avg, set after reading in avg.
string line;
vector< vector<double> > idf(topicSize,vector<double>(1));
vector<string> sv, pos, kw;
double max=0;
unsigned int maxPos, maxPosE;
string file, topic;
int inttopic;
double score;
int dl=0;
int possize;

ifstream idfFile;
ifstream inFile;
ofstream outFile;

idfFile.open("idf.txt");
if(idfFile.is_open()){
	//getline(idfFile,line);
	//sv=tokenizer(line, " ");
	//avg=atof(sv[1].c_str());
	while(!idfFile.eof()){
		getline(idfFile, line);
		if(idfFile.eof())break;
		sv=tokenizer(line," ");	
                if(atoi(sv[0].c_str())==-1){
                        continue;
                }
		//[0]=topic, [1]=xth term, [2]=idf.
		idf[atoi(sv[0].c_str())].push_back(atof(sv[2].c_str()));
	}
		
idfFile.close();
}
else{
	cout<<"Opening idf.txt failed.";
	exit(1);
}
C=b/avg;




outFile.open("scoredTopics.txt");
if(!outFile.is_open()) exit(1);

inFile.open("everything.txt");
if(inFile.is_open()){
while(getline(inFile,line)){
                sv=tokenizer(line,"#");
		file=sv[0];
		topic=sv[1];
		inttopic=atoi(sv[1].c_str());	

		pos=tokenizer(sv[2]," ");
		kw=tokenizer(sv[3]," ");


		int possize=pos.size();
		int ipos[possize], ikw[possize];
		for(int i=0; i<possize; i++){
			ipos[i]=atoi(pos[i].c_str());
			ikw[i]=atoi(kw[i].c_str());
		}
		for(int i=0; i<possize;i++){
		max=0;
		maxPos=0;
		maxPosE=0;
		int termC[maxTerm]={0};
		termC[ikw[i]]=1;

			for(int j=i+1; j<possize;j++){
			termC[ikw[j]]++;
			score=0;
			dl=ipos[j]-ipos[i]+1;
			if(dl<50){ continue;}
			for (int m=0; m<idf[inttopic].size()-1; m++){
			if(termC[m+1]==0){
 				continue;
			}
			score+=((idf[inttopic][m+1])*(termC[m+1])*A)/(termC[m+1]+k*(B+C*dl));

			}
			if(score>max){
				max=score;
				maxPos=ipos[i];
				maxPosE=ipos[j];
			}
			
			} //end j
		if(max!=0){
			outFile<<topic<<" "<<max<<" "<<maxPos<<" "<<maxPosE<<" "<<file<<endl;;
		}
		} // end i	

}
inFile.close();
}
else{
	cout<<"Failed to open everything.txt for reading."<<endl;
	exit(1);
}
outFile.close();

return 0;

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


