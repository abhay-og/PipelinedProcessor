#include<bits/stdc++.h>
using namespace std;

vector<string> maincode;
vector<string> maincode02;
map<string, int> instructaddr;
vector<string> instructbinary;
vector<string> final_code;

/*


R-type ins -> OPR rd,rs,rt
I-type ins -> OPR imm,rd,rs
B-type ins -> BRN ,address,rs,rt
J-type ins-> JUM address


Assembler code input is taken from the file code_w.txt and the binary output is stored in the file bin_output.txt

Functions used:
int_to_5bit_bin : used to convert int to 5 bit binary number
int_to_16bit_bin : used to convert int to 16 bit binary number
stoi : used to convert a decimal string into a number ex: stoi("-68943")=-68943

opcodes:
I-type : 001000
J-type : 000010
R-type : 000000

-> For R-type : shamt = 00000
[6-bit opcode] || [5-bit source reg1] || [5-bit source reg2] || [5-bit dest reg] || [5-bit shamt] || [6-bit function code]
The available operations are
ADD - 100000
SUB - 100010
MUL - 011000
ORR - 100101
AND - 100100
Sll - 000000
SRL - 000010

-> I-type instructions
[6bit opcode] || [5-bit source reg] || [5-bit dest reg] || [16-bit immdeate value]
The available operations are
ADI - 001000
ORI - 001101
ANI - 001100
XOI - 001110

-> J-type instructions
[6-bit opcode] || [26-bit address]
The available operation is
JUM

-> Branch type instructions
[6-bit opcode] || [5-bit reg1] || [5-bit reg2] || [16-bit address]
The available operations are
BEQ - 000100
BNE - 000101

*/


// int to string functions

string int_to_5bit_bin(int x){
    string s="";
    while(x){
        if(x&1)s.push_back('1');
        else
        s.push_back('0');
        x/=2;
    }
    while(s.length()<5)s.push_back('0');
    reverse(s.begin(),s.end());
    return s;
}

string int_to_16bit_bin(int x){
    string s="";
    bool t=1;
    if(x<0){
        t=0;
        x=pow(2,16)-abs(x);
    }
    while(x){
        if(x&1)s.push_back('1');
        else
        s.push_back('0');
        x/=2;
    }
    while(s.length()<15)s.push_back('0');
    if(!t)s.push_back('1');
    else s.push_back('0');
    reverse(s.begin(),s.end());
    return s;
}

string R_Type(string s){
    string res="000000"; 
    int a,b,c,p=3;
    if(s[p+2]!='$'){
        a=(s[p+1]-'0')*10+(s[p+2]-'0');
        p+=3;
    }
    else{
        a=s[p+1]-'0';
        p+=2;
    }
    if(s[p+2]!='$'){
        b=(s[p+1]-'0')*10+(s[p+2]-'0');
        p+=3;
    }
    else{
        b=s[p+1]-'0';
        p+=2;
    }
    if(p<s.length()-2){
        c=(s[p+1]-'0')*10+(s[p+2]-'0');
    }
    else{
        c=s[p+1]-'0';
    }
    res+=int_to_5bit_bin(b);
    res+=int_to_5bit_bin(c);
    res+=int_to_5bit_bin(a);
    res+="00000";
    return res;
}

string add_inst(string s){
    string res=R_Type(s);
    res+="100000";
    return res;
}

string sub_inst(string s){
    string res=R_Type(s);
    res+="100010";
    return res;
}

string mul_inst(string s){
    string res=R_Type(s);
    res+="011000";
    return res;
}


string and_inst(string s){
    string res=R_Type(s);
    res+="100100";
    return res;
}

string orr_inst(string s){
    string res=R_Type(s);
    res+="100101";
    return res;
}

string xor_inst(string s){
    string res=R_Type(s);
    res+="100110";
    return res;
}

string sll_inst(string s){
    string res=R_Type(s);
    res+="000000";
    return res;
}

string srl_inst(string s){
    string res=R_Type(s);
    res+="000010";
    return res;
}

// I-type instructions

string I_Type(string s){
    string res="",tt;
    int a,b,p=3,c=0;
    while(s[p++]!='$'){
        c++;
    }
    tt=int_to_16bit_bin(stoi(s.substr(3,c)));
    p=c+3;
    if(s[p+2]!='$'){
        a=(s[p+1]-'0')*10+(s[p+2]-'0');
        p+=3;
    }
    else{
        a=(s[p+1]-'0');
        p+=2;
    }
    if(p<s.length()-2){
        b=(s[p+1]-'0')*10+(s[p+2]-'0');
    }
    else{
        b=s[p+1]-'0';
    }
    res+=int_to_5bit_bin(b);
    res+=int_to_5bit_bin(a);
    res+=tt;
    return res;
}

string adi_inst(string s){
    string res="001000";
    res+=I_Type(s);
    return res;
}

string ani_inst(string s){
    string res="001100";
    res+=I_Type(s);
    return res;
}

string ori_inst(string s){
    string res="001101";
    res+=I_Type(s);
    return res;
}

string xoi_inst(string s){
    string res="001110";
    res+=I_Type(s);
    return res;
}


// J-type instructions

string jum_inst(string s, int pc){
    string res="";
    res+="0000100000000000";
    string temp="";
    for(int j=3;j<s.length();j++){
        temp.push_back(s[j]);
    }
    res+=int_to_16bit_bin(instructaddr[temp]);
    return res;
}

// Branch instructions

string Branch_type(string s, int pc){
   string res="",tem;
    int a,b,p=3,c=0;
    while(s[p]!='$'){
        tem.push_back(s[p]);
        c++,p++;
    }
    tem=int_to_16bit_bin(instructaddr[tem]);
    p=c+3;
    if(s[p+2]!='$'){
        a=(s[p+1]-'0')*10+(s[p+2]-'0');
        p+=3;
    }
    else{
        a=(s[p+1]-'0');
        p+=2;
    }
    if(p<s.length()-2){
        b=(s[p+1]-'0')*10+(s[p+2]-'0');
    }
    else{
        b=s[p+1]-'0';
    }
    res=int_to_5bit_bin(b);
    res+=int_to_5bit_bin(a);
    res+=tem;
    return res;
}

string beq_inst(string s, int pc){
    string res="000100";
    res+=Branch_type(s,pc);
    return res;
}

string bne_inst(string s, int pc){
    string res="000101";
    res+=Branch_type(s,pc);
    return res;
}


// No operation instruction
string NOP(){
    return "00100000000000000000000000000000";
}

// Utility functions

void input_from_file(){
    fstream txtfile;
    txtfile.open("code_w.txt",ios::in);
    if (txtfile.is_open()){
        string s;
        while(getline(txtfile,s)){
            s.erase(remove(s.begin(),s.end(),' '),s.end());
            if (s!=""){
                maincode.push_back(s);
            }
        }
        txtfile.close();
    }
    return;
}

void output_to_file(){
    ofstream f("bin_output.txt");
    for(auto x : instructbinary){
        f<<x<<"\n";
    }
    f<<"11111111111111111111111111111111\n";
    return;
}

void codedisplay_maincode(){
    for (auto it : maincode){
        cout<<it<<"\n";
    }
}

void codedisplay_instructbinary(){
    for (auto it : instructbinary){
        cout<<it<<"\n";
    }
}

void codedisplay_maincode02(){
    for (auto it : maincode02){
        cout<<it<<"\n";
    }
}

void addrassign(){
    for(auto s : maincode){
        if(s[s.length()-1]==':'){
            string temp="";
            for(int j=0;j<s.length()-1;j++){
                temp.push_back(s[j]);
            }
            instructaddr[temp]=maincode02.size();
        }
        else{
            maincode02.push_back(s);
        }
    }
    return;
}

void code_to_bin(){
    int count=0;
    for(auto s : maincode02){
        string t="";
        for(int i=0;i<3;i++)
        t.push_back(tolower(s[i]));
        if(t=="add"){
            instructbinary.push_back(add_inst(s));
        }
        else if(t=="sub"){
            instructbinary.push_back(sub_inst(s));
        }
        else if(t=="and"){
            instructbinary.push_back(and_inst(s));
        }
        else if(t=="orr"){
            instructbinary.push_back(orr_inst(s));
        }
        else if(t=="mul"){
            instructbinary.push_back(mul_inst(s));
        }
        else if(t=="xor"){
            instructbinary.push_back(xor_inst(s));
        }
        else if(t=="sll"){
            instructbinary.push_back(sll_inst(s));
        }
        else if(t=="srl"){
            instructbinary.push_back(srl_inst(s));
        }
        else if(t=="adi"){
            instructbinary.push_back(adi_inst(s));
        }
        else if(t=="xoi"){
            instructbinary.push_back(xoi_inst(s));
        }
        else if(t=="ani"){
            instructbinary.push_back(ani_inst(s));
        }
        else if(t=="ori"){
            instructbinary.push_back(ori_inst(s));
        }
        else if(t=="jum"){
            instructbinary.push_back(jum_inst(s,count));
        }
        else if(t=="bne"){
            instructbinary.push_back(bne_inst(s,count));
        }
        else if(t=="beq"){
            instructbinary.push_back(beq_inst(s,count));
        }
        else if(t=="nop"){
            instructbinary.push_back(NOP());
        }
        count++;
    }
}

// Climax 

int main(){
    input_from_file();
    codedisplay_maincode();
    addrassign();
    codedisplay_maincode02();
    code_to_bin();
    codedisplay_instructbinary();
    output_to_file();
}