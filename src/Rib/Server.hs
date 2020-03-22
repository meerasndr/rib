{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | Serve generated static files with HTTP
module Rib.Server
  ( serve,
  )
where

import Network.Wai.Application.Static (defaultFileServerSettings, ssListing, staticApp)
import qualified Network.Wai.Handler.Warp as Warp
import Relude
import WaiAppStatic.Types (StaticSettings)

-- | WAI Settings suited for serving statically generated websites.
staticSiteServerSettings :: FilePath -> StaticSettings
staticSiteServerSettings root =
  defaultSettings
    { ssListing = Nothing -- Disable directory listings
    }
  where
    defaultSettings = defaultFileServerSettings root

-- | Run a HTTP server to serve a directory of static files
--
-- Binds the server to host 127.0.0.1.
serve ::
  -- | Port number to bind to
  Int ->
  -- | Directory to serve.
  FilePath ->
  IO ()
serve port path = do
  putStrLn $ "[Rib] Serving " <> path <> " at http://" <> host <> ":" <> show port
  Warp.runSettings settings app
  where
    app = staticApp $ staticSiteServerSettings path
    host = "127.0.0.1"
    settings =
      Warp.setHost (fromString host)
        $ Warp.setPort port
        $ Warp.defaultSettings
