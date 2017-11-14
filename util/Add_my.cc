#include <ioModes.h>
#include <cassert>
#include <vector>
using namespace SEP;
std::string itoa(int i)
{
	std::string ans;
	if(i==0) return "0";
	while(i>0)
	{
		std::string temp="";
		char c=(i%10)+'0';
		temp+=c;
		ans=temp+ans;
		i/=10;
	}
	return ans;
}
int main(int argc, char **argv){

  ioModes modes(argc,argv);



  std::shared_ptr<genericIO>  io=modes.getDefaultIO();
  std::shared_ptr<paramObj> par=io->getParamObj();


  int in_num=par->getInt(std::string("num_shots"));
  std::vector<std::string> inputs;			//INPUTS HERE!
  std::string temp1="in";
  std::string temp2;
  for(int i=0;i<in_num;i++)
  {
	  temp2=temp1+itoa(i);
	  std::string in_i=par->getString(std::string(temp2));
	  inputs.push_back(in_i);
  }
  std::string in1=par->getString(std::string("in0"));

  std::string out=par->getString(std::string("out"));

  std::vector<std::shared_ptr<genericRegFile> > inp_vec;	//INP HERE!
//  std::shared_ptr<genericRegFile> inp1=io->getRegFile(in1,usageIn);
//  std::shared_ptr<genericRegFile> inp2=io->getRegFile(in2,usageIn);
  for(int i=0;i<in_num;i++)
  {
	  inp_vec.push_back(io->getRegFile(inputs[i],usageIn));
  }


//  std::shared_ptr<hypercube> hyperIn1=inp1->getHyper();
//  std::shared_ptr<hypercube> hyperIn2=inp2->getHyper();
  std::vector<std::shared_ptr<hypercube> > hyper_vec;
  for(int i=0;i<in_num;i++)
  {
	  hyper_vec.push_back(inp_vec[i]->getHyper());
	  if(i>0)
		  assert(hyper_vec[i]->sameSize(hyper_vec[0]));
  }

  std::shared_ptr<genericRegFile> outp=io->getRegFile(out,usageOut);

  outp->setHyper(hyper_vec[0]);
  outp->writeDescription();

  auto & hyperIn1 = hyper_vec[0];

  long long blockSize=100*1024*1024;
  float *inf1=new float[blockSize];
  float *inf2=new float[blockSize];

  long long n123=hyperIn1->getN123();

  for(int i=1;i<in_num;i++)
  {
	 long long done=0;
	 auto & inp1 = inp_vec[0];
	 auto & inp2 = inp_vec[i];
	 while(done!=n123){
		  long pass=std::min(n123-done,blockSize);
		  inp1->readFloatStream(inf1,pass);
		  inp2->readFloatStream(inf2,pass);
		  for(long long i=0;i < pass; i++) inf1[i]+=inf2[i]; 
		  outp->writeFloatStream(inf1,pass);
		  done+=pass;
	  }
  }
	  return 0;
}
