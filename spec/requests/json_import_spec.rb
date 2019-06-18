# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Json import", type: :request do
  it "creates a Record with parsed json data" do
    headers = {
      "ACCEPT" => "application/json"
    }
    post "/json", params: {
      "_id": 23887243,
      "_remote_id": "b4ac8c14-91c2-11e9-906e-28b67d68f390",
      "type": "article",
      "main_location_path": "/1/2/1217088/1735031/1735133/1748925/30766620/",
      "canonical": "/Lokales/Potsdam-Mittelmark/Bad-Belzig/Kabinett-beraet-in-Bad-Belzig",
      "section": "/Lokales/Potsdam-Mittelmark/Bad-Belzig",
      "portal_urls": [
        {
          "locationd_id": 30766620,
          "portal_url": "https://www.maz-online.de/Lokales/Potsdam-Mittelmark/Bad-Belzig/Kabinett-beraet-in-Bad-Belzig",
          "path": "/1/2/1217088/1735031/1735133/1748925/30766620/"
        },
        {
          "locationd_id": 30766621,
          "portal_url": "https://www.maz-online.de/Lokales/Potsdam-Mittelmark/Beelitz/Kabinett-beraet-in-Bad-Belzig",
          "path": "/1/2/1217088/1735031/1735133/28657473/30766621/"
        }
      ],
      "title": {
        "type": "text",
        "value": "Förderung für Breitbandausbau ist da"
      },
      "url_alias": {
        "type": "text",
        "value": "Kabinett berät in Bad Belzig"
      },
      "url": {
        "type": "text",
        "value": ""
      },
      "author_relation": {
        "type": "relation",
        "value": nil
      },
      "location_name": {
        "type": "text",
        "value": "Bad Belzig"
      },
      "intro": {
        "type": "richtext",
        "value": "<p>Die Landesregierung berät heute in Bad Belzig. Es ist die abschließende Tagung der Reihe „Kabinett vor Ort“. Aus dem Anlass wurden Fördergeld für das schnelle Internet überreicht.</p><p><!-- Methode uuid: \"b4ac8c14-91c2-11e9-906e-28b67d68f390\"--></p>\n"
      },
      "body": {
        "type": "richtext",
        "value": "<p>In der Reihe „Kabinett vor Ort“ berät die Landesregierung Brandenburg am Donnerstag nachmittag in Bad Belzig. Zum Auftakt hat Wirtschaftsstaatssekretär Hendrik Fischer einen Förderscheck an Landrat Wolfgang Blasig (SPD) überreicht. Es handelt sich um 17 Millionen Euro, mit denen der Breitbandausbau zwischen Havel und Fläming unterstützt werden soll.</p><p>Insgesamt braucht es dafür rund 50 Millionen Euro. Denn 11 500 Haushalte, knapp 300 Gewerbebetriebe und 90 Schulen gelten als unterversorgt.</p><p>Am Nachmittag haben einige Minister noch weitere Termine mit Politikern und Unternehmen aus Bad Belzig und Umgebung. <a href=\"https://www.maz-online.de/Lokales/Potsdam-Mittelmark/Beelitz/Dietmar-Woidke-in-Bad-Belzig-und-Beelitz\" target=\"_self\">Abends ist der Bürgerdialog im Deutschen Haus in Beelitz angesetzt, wo Ministerpräsident Dietmar Woidke (SPD) mit den Einwohnern der Spargelstadt ist Gespräch kommen will.</a></p><p><em>Von René Gaffron</em></p>\n"
      },
      "tags": {
        "type": "keyword",
        "value": [
          ""
        ]
      },
      "article_image": {
        "type": "image",
        "value": {
          "_id": "23887243-722374108",
          "width": "1024",
          "height": "683",
          "alternativeText": "Die Landesregierung tagt in der Reihe \"Kabinett vor Ort\" in Bad Belzig. Wirtschaftsstatssekretär Hendrik Fischer (2. v. l.)  überreicht aus dem Anlass einen Förderbescheid für den Breitbandausbau an Landrat Wolfgang Blasig (SPD).",
          "filename": "Foerderung-fuer-Breitbandausbau-ist-da.jpg",
          "url": "https://www.haz.de//var/storage/images/maz/lokales/potsdam-mittelmark/bad-belzig/kabinett-beraet-in-bad-belzig/722374108-1-ger-DE/Foerderung-fuer-Breitbandausbau-ist-da.jpg"
        }
      },
      "article_image_photographer": {
        "type": "text",
        "value": "René Gaffron"
      },
      "article_image_caption": {
        "type": "richtext",
        "value": "<p>Die Landesregierung tagt in der Reihe \"Kabinett vor Ort\" in Bad Belzig. Wirtschaftsstatssekretär Hendrik Fischer (2. v. l.) überreicht aus dem Anlass einen Förderbescheid für den Breitbandausbau an Landrat Wolfgang Blasig (SPD).</p>\n"
      },
      "publication_date": {
        "type": "datetime",
        "value": nil
      },
      "publish_date": {
        "type": "datetime",
        "value": nil
      },
      "show_publish_date": {
        "type": "bool",
        "value": true
      },
      "geo_location": {
        "type": "maplocation",
        "value": {
          "latitude": nil,
          "longitude": nil,
          "address": nil
        }
      },
      "print_id": {
        "type": "text",
        "value": ""
      },
      "related_objects": []
    }, headers: headers

    expect(response).to have_http_status(:created)
    expect(response.body).to include("News Article was successfully imported")
  end
end