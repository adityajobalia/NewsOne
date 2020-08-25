import { readData } from "../../Database/read";

function get_time_diff( datetime )
{
    // var datetime = typeof datetime !== 'undefined' ? datetime : "2014-01-01 01:02:03.123456";

     var datetime = new Date( datetime ).getTime();
    var now = new Date().getTime();
    var difference = now - datetime;
    var daysDifference = Math.floor(difference/1000/60/60/24);
    difference -= daysDifference*1000*60*60*24

    var hoursDifference = Math.floor(difference/1000/60/60);
    difference -= hoursDifference*1000*60*60

    var minutesDifference = Math.floor(difference/1000/60);
    difference -= minutesDifference*1000*60

    var secondsDifference = Math.floor(difference/1000);

    return {
     days: daysDifference,
     hours : hoursDifference,
     minutes : minutesDifference,
     seconds : secondsDifference

    } 
}

export const getDiscussion = async(event, context, callback) => {

    try {


        let getNewsparams = {
            TableName: process.env.Discussions,
            Key: {
                discussionid: event.pathParameters.discussionid,
            },
        };

        let result = await readData(getNewsparams);
        result.Item.createdAt = get_time_diff(result.Item.createdAt);
       result.Item.comments = result.Item.comments.map(comment =>{
        comment.createdAt = get_time_diff(comment.createdAt);
        return comment;
        });
        return {
            statusCode: 200,
            body: JSON.stringify({
                code: 0,
                data: result.Item  ,
                message: "Discussion Retrieved"
            })
        }

    } catch (err) {
        return {
            statusCode: 501,
            body: JSON.stringify({
                code: -1,
                data: {},
                message: err.message
            })
        }
    }

};


