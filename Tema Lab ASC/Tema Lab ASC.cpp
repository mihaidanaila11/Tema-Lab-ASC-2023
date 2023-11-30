#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int s[20][20];
int m, n, p, k, mod;

vector<int> locatii;


int countVecini(int i, int j) {
	int nr_vecini = 0;

	for (int l = -1; l < 2; l++) {  //verific vecinii
		for (int c = -1; c < 2; c++) {
			if (l == 0 and c == 0) c++; //daca ajung la elementu pe care il compar gen identitate
			if (s[i + l][j + c] == 1) nr_vecini += 1; //daca vecinul e viu il numar
		}
	}

	return nr_vecini;
}


void evolutie() {
	

	for (int i = 1; i <= m; i++) {
		for (int j = 1; j <= n; j++) { //verific fiecare element din matricea neextinsa
			if (s[i][j] == 0) { //verificam celulele moarte
				if (countVecini(i, j) == 3) { // conditie creare
				
					locatii.push_back(i); locatii.push_back(j); locatii.push_back(1); // salvez locatia celulelor de inviat
				
				}
			}
			else {
				if (countVecini(i, j) < 2) {
					locatii.push_back(i); locatii.push_back(j); locatii.push_back(0);
				}
				else if (countVecini(i, j) > 3) {
					locatii.push_back(i); locatii.push_back(j); locatii.push_back(0);
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
	cin >> m >> n >> p;


	for (int i = 0; i < p; i++) {
		int x, y;
		cin >> x >> y;
		s[x+1][y+1] = 1;
	}

	cin >> k;

	//0x00
	for (int c = 0; c < k; c++) {
		bool zero = true;
		printf("Gen %d\n", c);
		for (int i = 1; i <= m; i++) { // afisez matricea Sk
			for (int j = 1; j <= n; j++) {
				cout << s[i][j] << " ";
				if (s[i][j] == 1) {
					zero = false;
				}
			}
			cout << endl;
		}

		if (zero) { // daca e matricea nula nu mai continua
			break;
		}
		evolutie();
	}

		
	return 0;
}
