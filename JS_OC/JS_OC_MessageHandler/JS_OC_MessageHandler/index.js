
function scanClick() {
    window.webkit.messageHandlers.ScanAction.postMessage(null);
}

function shareClick() {
    window.webkit.messageHandlers.Share.postMessage({title:'测试分享的标题',content:'测试分享的内容',url:'http://m.rblcmall.com/share/openShare.htm?share_uuid=shdfxdfdsfsdfs&share_url=http://m.rblcmall.com/store_index_32787.htm&imagePath=http://c.hiphotos.baidu.com/image/pic/item/f3d3572c11dfa9ec78e256df60d0f703908fc12e.jpg'});
}

function locationClick() {
    window.webkit.messageHandlers.Location.postMessage(null);
}

function setLocation(location) {
    asyncAlert(location);
    document.getElementById("returnValue").value = location;
}

function getQRCode(result) {
    asyncAlert(result);
    document.getElementById("returnValue").value = result;
}

function colorClick() {
    window.webkit.messageHandlers.Color.postMessage([67,205,128,0.5]);
}

function payClick() {
    window.webkit.messageHandlers.Pay.postMessage({order_no:'201511120981234',channel:'wx',amount:1,subject:'粉色外套'});
}

function payResult(str) {
    asyncAlert(str);
    document.getElementById("returnValue").value = str;
}

function shareResult(channel_id,share_channel,share_url) {
    var content = channel_id+","+share_channel+","+share_url;
    asyncAlert(content);
    document.getElementById("returnValue").value = content;
}

function shake() {
    window.webkit.messageHandlers.Shake.postMessage(null);
}

function goBack() {
    window.webkit.messageHandlers.GoBack.postMessage(null);
}

function playSound() {
    window.webkit.messageHandlers.PlaySound.postMessage('shake_sound_male.wav');
}

function asyncAlert(content) {
    setTimeout(function(){
               alert(content);
               },1);
}

