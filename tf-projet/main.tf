/* 
File: main.tf
Description: This file sets up the base AWS provider, specifying the 'us-east-1' region as target region for the AWS services.
*/

provider "aws" {
  region  = "us-east-1"
}