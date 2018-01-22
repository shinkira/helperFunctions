function newMsg = addMsg(oldMsg,addedMsg)
    if isempty(oldMsg)
        newMsg = addedMsg;
    else
        newMsg = sprintf('%s\n%s',oldMsg,addedMsg);
    end
end