
# extend Genai::Common
# or simply =>  Genai::Common.offline?
# Genai::Common.network_offline?

module Genai
  # Only allow authenticated admins access to precious resources.
  module Common

    NATIONALITIES_BARD = [
      #**A**
"Afghan",
"Albanian",
"Algerian",
"American",
"Andorran",
"Angolan",
"Antiguan and Barbudan",
"Argentine",
"Armenian",
"Australian",
"Austrian",

#**B**
"Azerbaijani",
"Bahamian",
"Bahraini",
"Bangladeshi",
"Barbadian",
"Belarusian",
"Belgian",
"Belizean",
"Beninese",
"Bhutanese",
"Bolivian",
"Bosnian",
"Brazilian",

#**C**
"Cabo Verdean",
"Cambodian",
"Cameroonian",
"Canadian",
"Central African",
"Chadian",
"Chilean",
"Chinese",
"Colombian",
"Comorian",
"Congolese",
"Costa Rican",
"Croatian",
"Cuban",

#**D**
"Danish",
"Djiboutian",
"Dominican",
"Dominican Republic",

#**E**
"Ecuadorian",
"Egyptian",
"Equatorial Guinean",
"Eritrean",
"Estonian",
"Ethiopian",

#**F**
"Fijian",
"Filipino",
"Finnish",
"French",
"Gabonese",
"Gambian",
"Georgian",
"German",
"Ghanaian",
"Greek",
"Grenadian",

#**H**
"Haitian",
"Honduran",
"Hungarian",

#**I**
"Icelandic",
"Indian",
"Indonesian",
"Iranian",
"Iraqi",
"Irish",
"Israeli",
"Italian",

#**J**
"Jamaican",
"Japanese",
"Jordanian",

#**K**
"Kazakh",
"Kenyan",
"Kittitian and Nevisian",
"Kuwaiti",

#**L**
"Laotian",
"Latvian",
"Lebanese",
"Liberian",
"Libyan",
"Liechtensteiner",
"Lithuanian",
"Luxembourger",

#**M**
"Macedonian",
"Malagasy",
"Malawian",
"Malaysian",
"Maldivian",
"Malian",
"Maltese",
"Marshallese",
"Mauritanian",
"Mauritian",
"Mexican",
"Micronesian",
"Moldovan",
"Monacan",
"Mongolian",
"Montenegrin",
"Moroccan",
"Mozambican",

#**N**
"Namibian",
"Nauruan",
"Nepalese",
"New Zealander",
"Nicaraguan",
"Nigerian",
"North Korean",
"Northern Irish",
"Norwegian",

#**O**
"Omani",

#**P**
"Pakistani",
"Palauan",
"Palestinian",
"Panamanian",
"Papua New Guinean",
"Paraguayan",
"Peruvian",
"Philippine",
"Polish",
"Portuguese",

#**Q**
"Qatari",

#**R**
"Romanian",
"Russian",

#**S**
"Saint Lucian",
"Saint Vincentian and Grenadine",
"Samoan",
"San Marinoan",
"São Tomé and Príncipean",
"Saudi Arabian",
"Senegalese",
"Serbian",
"Seychellois",
"Sierra Leonean",
"Singaporean",
"Slovakian",
"Slovenian",
"Solomon Islander",
"Somali",
"South African",
"South Korean",
"South Sudanese",
"Spanish",
"Sri Lankan",
"Sudanese",
"Surinamese",
"Swazi",
"Swedish",

#**T**
"Tajik",
"Tanzanian",
"Thai",
"Timor-Lestean",
"Togolese",
"Tongan",
"Trinidadian and Tobagonian",
"Tunisian",
"Turkish",
"Tuvaluan",
"Ugandan",
"Ukrainian",
"Uruguayan",
"Uzbek",

#**V**
"Vanuatuan",
"Venezuelan",
"Vietnamese",

#**W**
"Welsh",
"West African",
"Yemeni",
"Zambian",
"Zimbabwean",

#**X**
"Xhosa",

#**Y**
"Yemeni",

#**Z**
"Zimbabwean",

]

    # from: https://www.gov.uk/government/publications/nationalities/list-of-nationalities
    # NATIONALITIES = [
    #   A
    #   'Afghan'	'Albanian'	'Algerian'	'American'
    #   'Andorran'	'Angolan'	'Anguillan	Citizen of Antigua and Barbuda',
    #   'Argentine'	'Armenian'	'Australian'	'Austrian'
    #   'Azerbaijani'
    #   B
    #   'Bahamian'	'Bahraini'	'Bangladeshi'	'Barbadian'
    #   'Belarusian'	'Belgian'	'Belizean'	'Beninese'
    #   'Bermudian'	'Bhutanese'	'Bolivian'	'Citizen of Bosnia and Herzegovina'
    #   'Botswanan'	'Brazilian'	'British'	'British Virgin Islander'
    #   'Bruneian'	'Bulgarian'	'Burkinan'	'Burmese'
    #   'Burundian'
    #   C
    #   'Cambodian'	'Cameroonian'	'Canadian'	'Cape Verdean'
    #   'Cayman Islander'	'Central African'	'Chadian'	'Chilean'
    #   'Chinese'	'Colombian'	'Comoran'	'Congolese (Congo)'
    #   'Congolese (DRC)'	'Cook Islander'	'Costa Rican'	'Croatian'
    #   'Cuban'	'Cymraes'	'Cymro'	'Cypriot'
    #   'Czech'
    #   D
    #   'Danish'	'Djiboutian'	'Dominican	Citizen of the Dominican Republic'
    #   'Dutch'
    #   E
    #   'East Timorese'	'Ecuadorean'	'Egyptian'	'Emirati'
    #   'English'	'Equatorial' 'Guinean'	'Eritrean'	'Estonian'
    #   'Ethiopian'
    #   F
    #   Faroese	Fijian	Filipino	Finnish
    #   French
    #   G
    #   Gabonese	Gambian	Georgian	German
    #   Ghanaian	Gibraltarian	Greek	Greenlandic
    #   Grenadian	Guamanian	Guatemalan	Citizen of Guinea-Bissau
    #   Guinean	Guyanese
    #   H
    #   Haitian	Honduran	Hong Konger	Hungarian
    #   I
    #   Icelandic	Indian	Indonesian	Iranian
    #   Iraqi	Irish	Israeli	Italian
    #   Ivorian
    #   J
    #   Jamaican	Japanese	Jordanian
    #   K
    #   Kazakh	Kenyan	Kittitian	Citizen of Kiribati
    #   Kosovan	Kuwaiti	Kyrgyz
    #   L
    #   Lao	Latvian	Lebanese	Liberian
    #   Libyan	Liechtenstein citizen	Lithuanian	Luxembourger
    #   M
    #   Macanese	Macedonian	Malagasy	Malawian
    #   Malaysian	Maldivian	Malian	Maltese
    #   Marshallese	Martiniquais	Mauritanian	Mauritian
    #   Mexican	Micronesian	Moldovan	Monegasque
    #   Mongolian	Montenegrin	Montserratian	Moroccan
    #   Mosotho	Mozambican
    #   N
    #   Namibian	Nauruan	Nepalese	New Zealander
    #   Nicaraguan	Nigerian	Nigerien	Niuean
    #   North Korean	Northern Irish	Norwegian
    #   O
    #   Omani
    #   P
    #   Pakistani	Palauan	Palestinian	Panamanian
    #   Papua New Guinean	Paraguayan	Peruvian	Pitcairn Islander
    #   Polish	Portuguese	Prydeinig	Puerto Rican
    #   Q
    #   Qatari
    #    R
    #   Romanian	Russian	Rwandan
    #   S
    #   Salvadorean	Sammarinese	Samoan	Sao Tomean
    #   Saudi Arabian	Scottish	Senegalese	Serbian
    #   Citizen of Seychelles	Sierra Leonean	Singaporean	Slovak
    #   Slovenian	Solomon Islander	Somali	South African
    #   South Korean	South Sudanese	Spanish	Sri Lankan
    #   St Helenian	St Lucian	Stateless	Sudanese
    #   Surinamese	Swazi	Swedish	Swiss
    #   Syrian
    #   T
    #   Taiwanese	Tajik	Tanzanian	Thai
    #   Togolese	Tongan	Trinidadian	Tristanian
    #   Tunisian	Turkish	Turkmen	Turks and Caicos Islander
    #   Tuvaluan
    #   U
    #   Ugandan	Ukrainian	Uruguayan	Uzbek
    #   V
    #   Vatican citizen	Citizen of Vanuatu	Venezuelan	Vietnamese
    #   Vincentian
    #   W
    #   "Wallisian,"	"Welsh",
    #   #Y
    #   "Yemeni",
    #   #Z
    #   "Zambian",	"Zimbabwean",
    # ]
    # def network_offline?()
    #   ENV.fetch('NETWORK_OFFLINE', false)
    # end

    def self.network_offline?()
      ENV.fetch('NETWORK_OFFLINE', false)
    end

  end
end
