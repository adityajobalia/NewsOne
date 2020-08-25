import { v4 } from "uuid";
import { createRecord } from "../../Database/create";
import { updateRecord } from "../../Database/update";
import { readData } from "../../Database/read";

export const createDiscussionForNews = async(event, context, callback) => {

    try {
        let discussionDataBody = JSON.parse(event.body);
        const timestamp = new Date().toUTCString();

        let discussionParams = {
            TableName: process.env.Discussions,
            Item: {
                discussionid: v4(),
                createdBy: {
                    userid: discussionDataBody.userid,
                    userDisplayName: discussionDataBody.username,
                    userImage: discussionDataBody.userImage
                },
                title: discussionDataBody.title,
                description: discussionDataBody.discription,
                createdAt: timestamp,
                comments: []


            },
        };
        // {
        //     comment: "",
        //     userid: "",
        //     userDisplayName: ""
        // }

        let discussionRecord = await createRecord(discussionParams);
        if (!discussionRecord) {
            return {
                statusCode: 200,
                body: JSON.stringify({
                    code: -1,
                    message: "Problem While creating Discussion"
                })
            }
        }
        let getNewsparams = {
            TableName: process.env.News,
            Key: {
                newsid: discussionDataBody.newsid,
            },
        };

        let result = await readData(getNewsparams);
        if (result.Item.discussions != undefined) {
            result.Item.discussions.push(discussionParams.Item.discussionid);
        } else {
            result.Item.discussions = [];
            result.Item.discussions.push(discussionParams.Item.discussionid);
        }

        const updateParams = {
            TableName: process.env.News,
            Key: {
                newsid: discussionDataBody.newsid,
            },
            ExpressionAttributeNames: {
                '#field': "discussions",
            },
            ExpressionAttributeValues: {
                ':value': result.Item.discussions,
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
                    message: "Discussion Created"
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