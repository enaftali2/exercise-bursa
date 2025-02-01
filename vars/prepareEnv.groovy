def call(Map params = [:]) {
    def envVars = [:]

    // Extracting Git information from the environment
    envVars['GIT_COMMIT'] = params.get('GIT_COMMIT', env.GIT_COMMIT ?: 'Unknown')
    envVars['GIT_BRANCH'] = params.get('GIT_BRANCH', env.GIT_BRANCH ?: 'Unknown')
    envVars['GIT_AUTHOR'] = params.get('GIT_AUTHOR', env.GIT_AUTHOR ?: 'Unknown')

    echo "SCM Trigger Details:"
    echo "Commit Hash: ${envVars['GIT_COMMIT']}"
    echo "Branch: ${envVars['GIT_BRANCH']}"
    echo "Author: ${envVars['GIT_AUTHOR']}"

    return envVars
}
