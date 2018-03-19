module dls.protocol.messages.general;

import dls.protocol.interfaces;
import dls.server : Server;

@("")
auto initialize(InitializeParams params)
{
    auto result = new InitializeResult();

    Server.initialized = true;
    Server.initState = params;

    if (!params.rootUri.isNull())
    {
        import dls.tools.tools : Tools;
        import dls.util.uri : Uri;

        auto rootUri = new Uri(params.rootUri);
        Tools.codeCompleter.importPath(rootUri);
        Tools.codeCompleter.importSelections(rootUri);
    }

    with (result)
    {
        capabilities = new ServerCapabilities();

        with (capabilities)
        {
            textDocumentSync = new TextDocumentSyncOptions();
            completionProvider = new CompletionOptions();
            documentFormattingProvider = true;

            with (textDocumentSync)
            {
                openClose = true;
                change = TextDocumentSyncKind.incremental;
            }

            with (completionProvider)
            {
                resolveProvider = false;
                triggerCharacters = ["."];
            }
        }
    }

    return result;
}

@("")
void initialized()
{
}

@("")
auto shutdown()
{
    Server.shutdown = true;
    return JSONValue(null);
}

@("")
void exit()
{
    Server.exit = true;
}

@("$")
void cancelRequest(JSONValue id)
{
}
