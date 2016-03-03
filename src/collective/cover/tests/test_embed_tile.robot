*** Settings ***

Resource  cover.robot
Library  Remote  ${PLONE_URL}/RobotRemote

Suite Setup  Open Test Browser
Suite Teardown  Close all browsers

*** Variables ***

${embed_tile_location}  'collective.cover.embed'
${embed_selector}  ul#item-list li.ui-draggable
${tile_selector}  div.tile-container div.tile
${title_field_id}  collective-cover-embed-title
${title_sample}  Some text for title
${edit_link_selector}  a.edit-tile-link

*** Test cases ***

Test Embed Tile
    Enable Autologin as  Site Administrator
    Go to Homepage
    Create Cover  Title  Description

    # add tile to the layout
    Open Layout Tab
    Add Tile  ${embed_tile_location}
    Save Cover Layout

    # as tile is empty, we see default message
    Compose Cover
    Page Should Contain  Please edit the tile to add the code to be embedded.

    # edit the tile and check AJAX refresh
    Compose Cover
    Click Link  css=${edit_link_selector}
    Wait until page contains element  id=${title_field_id}
    Input Text  id=${title_field_id}  ${title_sample}
    Click Button  Save
    Wait Until Page Contains  ${title_sample}

    # delete the tile
    Open Layout Tab
    Delete Tile
    Save Cover Layout
