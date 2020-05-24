class UndoOptions {
	bool hasUndoOnce;
	int overId;
	bool hasWicket;
	int strikeBatsmanId;
	int outBatsmanId;

	UndoOptions() {
		hasUndoOnce = true;
		overId = 0;
		strikeBatsmanId = 0;
		hasWicket = false;
		outBatsmanId = 0;
	}
}