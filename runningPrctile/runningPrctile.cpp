#define _CRT_SECURE_NO_WARNINGS
#define _SCL_SECURE_NO_WARNINGS

#include <iostream>
#include <string>
#include <algorithm> 
#include <vector>

using namespace std;

template <typename DataType>
void runningPrctile(DataType* dataArray, DataType* resultArray,
	const size_t dataArrayLength, const size_t winLength,
	size_t nth) {

	// I tested a multiset-based implementation of this function, it was slower than the vector based version.
	vector<DataType> runningWin(dataArray, dataArray + winLength);

	sort(runningWin.begin(), runningWin.end()); // Start sorted so we can binary search to find oldest element.
	
	unsigned int iNext = 0;
	vector<DataType>::iterator pOldestElement;
	vector<DataType>::iterator pNextElement;
	vector<DataType>::iterator i;

	// Processing loop:
	for (unsigned int iWinStart = 0; iWinStart < dataArrayLength - winLength - 1; iWinStart++){

		// Make runningWin-sized sub array. at each step, remember which was the "oldest" element.
		// (this is simply the i-nWindow-th element of the input vector).
		// Then, swap out the oldest element for the new element.
		iNext = iWinStart + winLength;
		
		// runningWin is sorted, so we can simply record the current result:
		resultArray[iWinStart+winLength/2] = runningWin[nth];

		// Find which element is the "oldest" in runningWin:
		pOldestElement = lower_bound(runningWin.begin(), runningWin.end(), dataArray[iWinStart]);

		// Find where the next element should go:
		pNextElement = lower_bound(runningWin.begin(), runningWin.end(), dataArray[iNext]);

		// Swap out the oldest for the next array, maintaining the order:
		if (pOldestElement < pNextElement) {
			for (i = pOldestElement; i < pNextElement && i < runningWin.begin() + winLength; ++i){
				*i = *(i + 1);
			}

			*(pNextElement-1) = dataArray[iNext];
		}
		else {
			for (i = pOldestElement; i > pNextElement; --i){
				*i = *(i - 1);
			}

			*pNextElement = dataArray[iNext];
		}

		if (iWinStart % 10000 == 0){
			cout << iWinStart << endl;
		}
	}
}