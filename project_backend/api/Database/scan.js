import { DynamoDB } from "aws-sdk";


export const getAllData = async(params) => {
    const client = new DynamoDB.DocumentClient();

    return client.scan(params).promise();
};