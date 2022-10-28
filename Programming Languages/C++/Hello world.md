```
#include <iostream> // include library

using namespace std; // use specific pacakge from library, if not you have to fully qualify cout like std::cout

  

int main() { // entry point function

  

    cout << "Hello world!"; // need to terminate lines with ;
	cout << "Hello world!" << endl; //add new line after 
    return 0;

}
```

compile
g++ -o outputbinaryname hello-world.cpp


int, float, bool and char are basic datatypes
include string to use string datatype


## Variables

type variablename and assignment
int x = 2;
cout << x;


Contant variables
cont int x = 2; // variable cannot be changes or read only 



Reading values and store in variable

```c++
string n;
cin >> n;
```

Check for failures
```c++
int n;
cin >> n;
cout << cin.fail(); // boolean to show if the previous cin command worked
```

Clear failures
```c++
int b;
cin >> b;
cin.clear(); clear cin error 
cin.ignore(100000, ''\n'); ignore error based on number of chars and skip to the next line

```

Arrays
```c++
int varname[size of array] = {1,3,4,5};
// can also be , automatically infer the size based on the initialization
int varname[] = {1,3,4,5};

int arr[] = {1,2,3,4};
cout << arr[0];
```

Size of arrays
```cpp
    cout << "Size of array: "<< sizeof(arr)/sizeof(arr[0]) << endl; // need to get size of array and divide by the first element
```

loops

for

```cpp

for (int i = 0; i < 5; i++)

    {

        cout << "Printing Line #" << i << endl;

    }

int arr[] = {1,2,3,4,5}

for(int i=0; i<sizeof(arr)/sizeof(arr[0]); i++) {
	cout << i << endl;
}
```

while

```cpp
int i = 0;
while (i < 10) {
	cout << i << endl;
	i++;
}

int input = -1;
while (input != 1 || input != 2) {
	cout << "Enter 1 or 2: "
	cin >> input
}

// another way using break, can be used in for 

while(true) {
	cout << "Enter 1 or 2: ";
	cin >> input;
	if(input == 1 || input == 2) {
		break;	
	}
}

for( int i=0; i< 10; i++) {
	cout << "Number " << i << end;
	if( i == 2) {
		cout << "You found the number"; 
		continue; // skip record
	}
}

int x = 0;
do {

	x++;
} while (x<9);

// run do at least once 
```


switch
```cpp

int x = 2;

switch(x + 1) {
	case 1: 
		cout << " Value is 1";
		break;
	case 2:
		cout << "Value is 2";
		break;
	default:
		cout << "default";
		break;
}
```


Strings
```cpp
#include <string>

int main() {
	string str = "hello string world";
	cout << str[1]; //print second char
	cout << str.size(); // print string size or
	cout << str.length();

	

}

```


References &

```cpp

int a =2;
int &b = a; //b is the reference of a, b is telling where a is, must be initialized or cannot be initalized to null and must be the same datatype as the original

cout << a << endl;
cout << b << endl; // will print the same values

```

Pointers *
![](https://i.imgur.com/nvHcQHZ.png)

```cpp

// pointer stores the memory location of the var, reference points to the same location 

int x = 2;
int *y = &x; // need not be initialized 

cout << x << endl;
cout << &x << endl;
cout << y << endl; // prints memory of the x
cout << &y << endl; // memory address of y
cout << *y << endl; // print value of x . this is called dereferencing 


int x1[] = {1,2,3}
int *y1 = x1 // need not point to the address as array x1 will have the address
```


Tuples
```cpp
#include <tuple>
int main() {
	tuple <int, string> person(20, "Tim");
	cout << get<0>(person) << endl; // access first element
	get<0>(person) = "Bill";
	cout << get<0>(person) << endl; // print changed value

	tuple <int, char> things;
	things = make_tuple(23, 'h'); // initializing
	cout << get<1>(things) << endl;

	// Decompose tuple
	tuple <int, int> t1 = make_tuple(1,2);
	tuple <char, bool> t2 = make_tuple('h',true);
	int x,y;

	tie(x,y) = t1;
	cout << x << y << endl;

	// concat
	tuple <int, int, char, bool> t3 = tuple_cat(t1 ,t2); // or
	auto t4 = tuple_cat(t1,t2);
}
```


Maps
```cpp

#include <map>
using namespace std;

int main() {
	map<char, int> mp = {
		{'T', 1},
		{'s', 2},
		{'r', 5}
	};
	cout << mp['T'] << endl;
	mp['U'] = 9; // insert values, or
	mp.insert(pair<char, int>('U',10));

// erase
	mp.erase('U');
//check if empty
	mp.empty();
//size
	mp.size();

// iterate

for(auto itr = mp.begin(); itr != mp.end(); ++itr) { // created iterator object pointer
	
	cout << (*itr).first << endl; // or first prints key and second prints value
	cout << itr->second << endl;
}

```

Vectors
```cpp 
// vectors no size declaration as arrays

#include <vector>

int main() {
	vector<int> v1 = {1,2,3}
	cout << v1.front() << end;
	cout << v1.size() << end;
	cout << v1.capacity() << end; // get the number of elements that this vector can store
	v1.push_back(9); // add an element to the end
	v1.pop_back(); // remove last element
	v1.shrint_to_fit(); // update capacity
	v1.insert(v1.begin(), 6); // or
	v1.insert(&v1[0], 6)
	cout << v1[0] << endl;
	v1.erase(&v1[0])

// iterate

for(int i=0; i< v1.size() ; ++i) {
	cout << v1[i] << endl;
} // or

for(auto itr = v1.begin; itr != v1.end; ++itr) {
	cout << *itr << endl;
}
	
}
```

set
```cpp

#include <set>

int main() {

	set<char> s1 = {'C', 'D', 'D', 'S'};
	s1.insert(&v1[0], 'T')
	cout << v1[0] << endl;
	s1.erase(&v1[0])
	
for(auto itr = s1.begin; itr != s1.end; ++itr) {
	cout << *itr << endl;
}	

	if(s1.find('C') == s1.end()) {
		cout << "cound not find C" << endl;
	} else {
		cout << "found C" << endl;
	}
}
```

functions
```cpp

int add(int x, int y) {
	return x + y;
}


int sub(int x, int y, int z=0) { // optional parameter
	return x - y + z;
}
int main() {
	cout << add(1,2) << endl;
}
```