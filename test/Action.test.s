( function _Action_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;
const core = require( '@actions/core' );

// --
// test
// --

function retryFetchActionWithoutTagOrHash( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  const isTestContainer = _.process.insideTestContainer();

  const testAction = 'dmvict/test.action';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

//

function retryFetchActionWithTag( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  const isTestContainer = _.process.insideTestContainer();

  const testAction = 'dmvict/test.action@v0.0.2';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

//

function retryFetchActionWithHash( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const testAction = 'dmvict/test.action';
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  const isTestContainer = _.process.insideTestContainer();

  /* - */

  actionSetup().then( () =>
  {
    test.case = 'full hash, enought attempts';
    core.exportVariable( `INPUT_ACTION`, `${ testAction }@e7a23fbc543bef807cb8a62825de2195ac6fe646` );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* */

  actionSetup().then( () =>
  {
    test.case = 'partial hash, enought attempts';
    core.exportVariable( `INPUT_ACTION`, `${ testAction }@e7a23fb` );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

//

function retryWithOptionAttemptLimit( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  const isTestContainer = _.process.insideTestContainer();

  const testAction = 'dmvict/test.action@v0.0.2';
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'default number of attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '2' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 2 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 2 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 2 attempts/ ), 1 );
    test.identical( _.strCount( op.output, 'Success' ), 0 );
    return null;
  });

  /* */
  a.ready.then( () =>
  {
    test.case = 'not enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '3' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 1 );
    test.identical( _.strCount( op.output, 'Success' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'enought attempts';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

retryWithOptionAttemptLimit.timeOut = 120000;

//

function retryWithOptionAttemptDelay( test )
{
  const a = test.assetFor( false );
  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const testAction = 'dmvict/test.action@v0.0.2';
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  const isTestContainer = _.process.insideTestContainer();
  actionSetup();

  /* - */

  var start;
  a.ready.then( () =>
  {
    test.case = 'enought attempts, default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    start = _.time.now();
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    var spent = _.time.now() - start;
    test.le( spent, 6000 );
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'enought attempts, not default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'value : 0' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    core.exportVariable( `INPUT_ATTEMPT_DELAY`, '4000' );
    start = _.time.now();
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 12000 );
    test.identical( op.exitCode, 0 );
    if( !isTestContainer )
    test.ge( _.strCount( op.output, '::set-env' ), 3 );
    test.identical( _.strCount( op.output, '::error::Wrong attempt' ), 3 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 3 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Success' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

//

function retryWithExternalActionOnLocal( test )
{
  const a = test.assetFor( false );

  if( _.process.insideTestContainer() )
  return test.true( true  );

  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const testAction = 'actions/setup-node@v2.3.0';
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts, default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'node-version : 15.x' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '::debug::isExplicit:' ), 4 );
    test.identical( _.strCount( op.output, '::debug::explicit? false' ), 4 );
    test.identical( _.strCount( op.output, '::error::Expected RUNNER_TOOL_CACHE to be defined' ), 4 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 4 attempts/ ), 1 );
    test.identical( _.strCount( op.output, 'Attempting to download 15.x' ), 0 );
    test.identical( _.strCount( op.output, 'Not found in manifest.  Falling back to download directly from Node' ), 0 );
    test.identical( _.strCount( op.output, /Acquiring 15.\d+\.\d+/ ), 0 );
    test.identical( _.strCount( op.output, 'Extracting ...' ), 0 );
    test.identical( _.strCount( op.output, 'Adding to the cache' ), 0 );
    test.identical( _.strCount( op.output, 'Done' ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

retryWithExternalActionOnLocal.timeOut = 120000;

//

function retryWithExternalActionOnRemote( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true  );

  const actionRepo = 'https://github.com/Wandalen/wretry.action.git';
  const actionPath = a.abs( '_action/actions/wretry.action/v1' );
  const testAction = 'actions/setup-node@v2.3.0';
  const execPath = `node ${ a.path.nativize( a.abs( actionPath, 'src/Index.js' ) ) }`;
  actionSetup();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'enought attempts, default value of attempt_delay';
    core.exportVariable( `INPUT_ACTION`, testAction );
    core.exportVariable( `INPUT_WITH`, 'node-version : 15.x' );
    core.exportVariable( `INPUT_ATTEMPT_LIMIT`, '4' );
    return null;
  });

  a.shellNonThrowing({ currentPath : actionPath, execPath });
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.ge( _.strCount( op.output, '::debug::isExplicit:' ), 0 );
    test.ge( _.strCount( op.output, '::debug::explicit? false' ), 0 );
    test.identical( _.strCount( op.output, '::error::Expected RUNNER_TOOL_CACHE to be defined' ), 0 );
    test.identical( _.strCount( op.output, /::error::undefined.*Attempts is exhausted, made 4 attempts/ ), 0 );
    test.identical( _.strCount( op.output, 'Attempting to download 15.x' ), 1 );
    test.identical( _.strCount( op.output, 'Not found in manifest.  Falling back to download directly from Node' ), 1 );
    test.identical( _.strCount( op.output, /Acquiring 15.\d+\.\d+/ ), 1 );
    test.identical( _.strCount( op.output, 'Extracting ...' ), 1 );
    test.identical( _.strCount( op.output, 'Adding to the cache' ), 1 );
    test.identical( _.strCount( op.output, 'Done' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function actionSetup()
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.dirMake( actionPath );
      return null;
    });
    a.shell( `git clone ${ actionRepo } ${ a.path.nativize( actionPath ) }` );
    a.shell( `node ${ a.path.nativize( a.abs( actionPath, 'src/Setup.js' ) ) }` );
    return a.ready;
  }
}

retryWithExternalActionOnRemote.timeOut = 120000;

// --
// declare
// --

const Proto =
{
  name : 'Action',
  silencing : 1,
  routineTimeOut : 60000,

  tests :
  {
    retryFetchActionWithoutTagOrHash,
    retryFetchActionWithTag,
    retryFetchActionWithHash,

    retryWithOptionAttemptLimit,
    retryWithOptionAttemptDelay,

    retryWithExternalActionOnLocal,
    retryWithExternalActionOnRemote,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

