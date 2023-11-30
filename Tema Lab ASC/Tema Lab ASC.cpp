#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int s[20][20];
int m, n, p, k;

vector<int> locatii;

void evolutie() {
	

	for (int i = 1; i <= m; i++) {
		for (int j = 1; j <= n; j++) { //verific fiecare element din matricea neextinsa
			if (s[i][j] == 0) { //verificam celulele moarte
				int nr_vecini = 0;
				

				for (int l = -1; l < 2; l++) {  //verific vecinii
					for (int c = -1; c < 2; c++) {
						if (l == 0 and c == 0 ) c++; //daca ajung la elementu pe care il compar gen identitate
						if (s[i + l][j + c] == 1) nr_vecini += 1; //daca vecinul e viu il numar
					}
				}
				if (nr_vecini == 3) { // conditie creare
				
					locatii.push_back(i); locatii.push_back(j); locatii.push_back(1); // salvez locatia celulelor de inviat
				
				}

				
				

			}

			
		}
	}

	for (int i = 0; i < locatii.size(); i+=3) {
		s[locatii[i]][locatii[i + 1]] = locatii[i + 2];
	}
	locatii.clear();

}


int main()
{
	cin >> m >> n >> p >> k;


	for (int i = 0; i < p; i++) {
		int x, y;
		cin >> x >> y;
		s[x+1][y+1] = 1;
	}

	//Matricea extinsa
	/*
	for (int i = 0; i < m+2; i++) {
		for (int j = 0; j < n+2; j++) {
			cout << s[i][j] << " ";
		}
		cout << endl;
	}*/
	
	

	cout << "Gen 0" << endl;
	for (int i = 1; i <= m; i++) {
		for (int j = 1; j <= n; j++) {
			cout << s[i][j] << " ";
		}
		cout << endl;
	}

	evolutie();

	cout << "Gen 1" << endl;
	for (int i = 1; i <= m; i++) {
		for (int j = 1; j <= n; j++) {
			cout << s[i][j] << " ";
		}
		cout << endl;
	}
		

	return 0;
}

/*
5 5 3 1
0 1
1 0
1 1


5 5 4 1
0 4
1 2
2 1
2 3
*/