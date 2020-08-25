import { DynamoDB } from "aws-sdk";
export const queryDB = async(params) => {
    const client = new DynamoDB.DocumentClient();
    return client.query(params).promise();

};