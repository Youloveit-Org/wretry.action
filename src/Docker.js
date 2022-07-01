const core = require( '@actions/core' );
if( typeof wTools === 'undefined' )
require( '../node_modules/Joined.s' );
const _ = wTools;
const ChildProcess = require( 'child_process' );

//

/*
   To run commands synchronously and with no `deasync` this wrapper is used because
   _.process uses Consequence in each `start*` routine and for synchronous execution it requires `deasync`.
   `deasync` is the binary module. To prevent failures during action build and decrease time of setup the action,
   we exclude `deasync` and compile action code.
*/

function execSyncNonThrowing( command )
{
  try
  {
    return ChildProcess.execSync( command, { stdio : 'pipe' } );
  }
  catch( err )
  {
    _.error.attend( err );
    return err;
  }
}

//

function exists()
{
  return !_.error.is( execSyncNonThrowing( 'docker -v' ) );
}

//

function imageBuild( actionPath, image )
{
  const docker = this;

  _.sure
  (
    docker.exists(),
    'Current OS has no Docker utility.\n'
    + 'Please, visit https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#preinstalled-software\n'
    + 'and select valid workflow runner.'
  );

  if( image === 'Dockerfile' )
  {
    const actionName = _.path.name( actionPath );
    const imageName = `${ actionName }_repo:${ actionName }_tag`.toLowerCase();
    const dockerfilePath = _.path.join( actionPath, 'Dockerfile' );
    const command = `docker build -t ${ imageName } -f ${ dockerfilePath } ${ actionPath }`;
    const build = execSyncNonThrowing( command );
    if( _.error.is( build ) )
    throw _.error.brief( build );

    core.info( `Dockerfile for action : ${ dockerfilePath }.` );
    core.info( command );
    core.info( build.toString() );

    return imageName;
  }

  _.sure( false, `The action does not support requested Docker image type "${ image }". Please, open an issue with the request for the feature.` );
}

//

function runCommandForm( imageName, inputs )
{
  const [ repo, tag ] = imageName.split( ':' );
  _.sure( _.str.defined( repo) && _.str.defined( tag ), 'Expects image name in format "[repo]:[tag]".' )
  const command = [ `docker run --name ${ tag } --label ${ repo } --workdir /github/workspace --rm` ];
  const env_keys = _.map.keys( JSON.parse( core.getInput( 'env_context' ) ) );
  const inputs_keys = _.map.keys( inputs );
  const postfix_command_envs =
  [
    'HOME',
    'GITHUB_JOB',
    'GITHUB_REF',
    'GITHUB_SHA',
    'GITHUB_REPOSITORY',
    'GITHUB_REPOSITORY_OWNER',
    'GITHUB_RUN_ID',
    'GITHUB_RUN_NUMBER',
    'GITHUB_RETENTION_DAYS',
    'GITHUB_RUN_ATTEMPT',
    'GITHUB_ACTOR',
    'GITHUB_WORKFLOW',
    'GITHUB_HEAD_REF',
    'GITHUB_BASE_REF',
    'GITHUB_EVENT_NAME',
    'GITHUB_SERVER_URL',
    'GITHUB_API_URL',
    'GITHUB_GRAPHQL_URL',
    'GITHUB_REF_NAME',
    'GITHUB_REF_PROTECTED',
    'GITHUB_REF_TYPE',
    'GITHUB_WORKSPACE',
    'GITHUB_ACTION',
    'GITHUB_EVENT_PATH',
    'GITHUB_ACTION_REPOSITORY',
    'GITHUB_ACTION_REF',
    'GITHUB_PATH',
    'GITHUB_ENV',
    'GITHUB_STEP_SUMMARY',
    'RUNNER_OS',
    'RUNNER_ARCH',
    'RUNNER_NAME',
    'RUNNER_TOOL_CACHE',
    'RUNNER_TEMP',
    'RUNNER_WORKSPACE',
    'ACTIONS_RUNTIME_URL',
    'ACTIONS_RUNTIME_TOKEN',
    'ACTIONS_CACHE_URL',
    'GITHUB_ACTIONS=true',
    'CI=true'
  ];
  const postfix_command_paths =
  [
    '"/var/run/docker.sock":"/var/run/docker.sock"',
    '"/home/runner/work/_temp/_github_home":"/github/home"',
    '"/home/runner/work/_temp/_github_workflow":"/github/workflow"',
    '"/home/runner/work/_temp/_runner_file_commands":"/github/file_commands"',
    `"${ process.env.GITHUB_WORKSPACE }":"/github/workspace"`
  ];

  /* */

  if( env_keys.length > 0 )
  command.push( '-e', env_keys.join( ' -e ' ) );
  if( inputs_keys.length > 0 )
  command.push( '-e', inputs_keys.join( ' -e ' ) );
  command.push( '-e', postfix_command_envs.join( ' -e ' ) );
  command.push( '-v', postfix_command_paths.join( ' -v ' ) );
  command.push( imageName );

  return command.join( ' ' );
}

// --
// export
// --

const Self =
{
  exists,
  imageBuild,
  runCommandForm,
};

module.exports = Self;
