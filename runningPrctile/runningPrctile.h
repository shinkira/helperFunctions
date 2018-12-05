#ifndef runningPrctile_h
#define runningPrctile_h


template <typename DataType>
void runningPrctile(DataType* dataArray, DataType* resultArray,
	const size_t dataArrayLength, const size_t winLength,
	size_t nth);

#endif
