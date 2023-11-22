# This space is for various RPM Postman/Insomnia collections



## .github
Contains a CODEOWNERS file to notify senior developers when PRs are opened https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners#about-code-owners

## .infrastructure
Contains a basic terraform file for getting started setting up azure infrastructure using terraform.  Other examples of working terraform can be found in the following repositories
- https://github.com/loadrpm/TurvoWebhooks/tree/master/.infrastructure
- https://github.com/loadrpm/CleanOrdersValidationRulesEngine/tree/main/.infrastructure

## .pipelines
Contains two starter Azure Dev Ops pipelines.  `azure-pipelines.yaml` will typically be the pipeline that builds your main project and `infrastructure-pipeline.yaml` is the pipeline which runs terraform to provision your infrastructure and execute your IAC solution
