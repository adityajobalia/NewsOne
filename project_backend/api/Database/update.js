import { DynamoDB } from "aws-sdk";
export const updateRecord = async(params) => {

    try {
        const client = new DynamoDB.DocumentClient();
        let { error, result } = await client.update(params).promise();
        if (error) {
            return { error: error.message, result: {} };
        } else {
            return { error: "", result };
        }


    } catch (e) {
        return { error: e.message, result: {} };
    }

};