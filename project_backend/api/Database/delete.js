import { DynamoDB } from "aws-sdk";



export const removeRecord = async(params) => {

    try {
        const client = new DynamoDB.DocumentClient();
        let err = await client.delete(params).promise();
        if (err) return false;

        return true;
    } catch (e) {
        return false;
    }

}