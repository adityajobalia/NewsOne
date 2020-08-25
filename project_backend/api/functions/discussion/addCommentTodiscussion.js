import { updateRecord } from "../../Database/update";
import { readData } from "../../Database/read";

export const addComment = async(event, context, callback) => {
    try {
        let commentDataBody = JSON.parse(event.body);
        const timestamp = new Date().toUTCString();



        let getDiscussionparams = {
            TableName: process.env.Discussions,
            Key: {
                discussionid: commentDataBody.discussionid,
            },
        };

        let result = await readData(getDiscussionparams);
        if (result.Item != undefined) {
            let comment = {
                comment: commentDataBody.comment,
                userid: commentDataBody.userid,
                userDisplayName: commentDataBody.userDisplayName,
                userImage: commentDataBody.userImage,
                createdAt: timestamp
            }
            result.Item.comments.push(comment);
            const updateParams = {
                TableName: process.env.Discussions,
                Key: {
                    discussionid: commentDataBody.discussionid,
                },
                ExpressionAttributeNames: {
                    '#field': "comments",
                },
                ExpressionAttributeValues: {
                    ':value': result.Item.comments,
                },
                UpdateExpression: 'SET #field = :value',
                ReturnValues: 'ALL_NEW',
            };
            let { error, updatedresult } = await updateRecord(updateParams);
            if (!error) {

                return {
                    statusCode: 200,
                    body: JSON.stringify({
                        code: 0,
                        message: "Comment Added"
                    })
                }
            } else {
                return {
                    statusCode: 200,
                    body: JSON.stringify({
                        code: -1,
                        message: error.message
                    })
                }
            }

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