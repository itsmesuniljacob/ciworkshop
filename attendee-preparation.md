# Prerequisites for CI workshop

This document contain the information for installing necessary pre-requisites for all participants who are attending the CI workshop session. 

Below are some of the imperative requirements:

1. Create a free Github account if you do not already have one - see [Signing up for a new GitHub Account](https://help.github.com/articles/signing-up-for-a-new-github-account/)

2. Add a new SSH key to your github account - see [Connecting to GitHub with SSH](https://help.github.com/articles/connecting-to-github-with-ssh/)

3. Install Gitbash in your system from [https://git-scm.com/downloads](https://git-scm.com/downloads)

4. Run Git configuration script [setup-scripts/Set-GitConfiguration.ps1](scripts/Set-GitConfiguration.ps1)

5. Create a free Travis CI account if you do not already have one using [https://travis-ci.org/](https://travis-ci.org/)

6. Install Java and set JAVA_HOME if not already done using [setup-scripts/Install-Java.ps1](setup-scripts/Install-Java.ps1)

   **Note**: Please start up *PowerShell* as *admin*. Mostly, we may need to execute the below command before running *Install_Java* script. 

   `Set-ExecutionPolicy Unrestricted`

   Once the above command has been executed successfully you can run the *Install_Java* script

7. Clone the initial program for the workshop from [ci-workshop-code/](ci-workshop-code/)
