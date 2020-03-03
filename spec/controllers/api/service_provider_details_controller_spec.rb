require 'rails_helper'

RSpec.describe ServiceProviderDetailsController, :type => :request do

  describe "create_catalog_entry" do

    let(:client_application) {FactoryBot.build(:client_application)}
    let(:user) {FactoryBot.create(:user, client_application: client_application)}

    let(:params) do
      {catalog_data: { url: "test.com",
                       GeoScope: {Scope: "Virtual", Neighborhoods: "test", ServiceAreaName: "test", State: "state", Country: "US", Region: "region", City: "city", County: "county" },
                       OrganizationName: {InactiveCatalog: true, OrganizationName: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                          OrgDescription: [{Text: "easier", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                          OrganizationDescriptionDisplay: "orgsesdisplay", HomePageURL: "https://demo.commonhealthcore.org", Type: "Govt" },
                       OrgSites: [{AdminSite: true, ServiceDeliverySite: true, ResourceDirectory: true, InactiveSite: true, LocationName: "test",
                                   Webpage: "webpage", SiteReference: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                   Addr1: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                   Addr2: "address_2", AddrCity: "city", AddrState: "state", AddrZip: 22222, SelectSiteID: 1,
                                   POCs: [{id: 1, poc: {Name: "ee", MobilePhone: 1234567890, OfficePhone: 1234567890, Email: "test@gmail.com", Title: "title",
                                                        Referrals: "referal", ContactPage: "https://demo.commonhealthcore.org", defaultPOC: true}}] }],
                       Programs: [{InactiveProgram: true, ProgramName: "pgname", ContactWebPage: "https://demo.commonhealthcore.org", QuickConnectWebPage: "https://demo.commonhealthcore.org",
                                   ProgramWebPage: "https://demo.commonhealthcore.org", ProgramDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                   ProgramDescriptionDisplay: "pdescdisplay", PopulationDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                                   PopulationDescriptionDisplay: "popdescdisplay", P_Any: true, P_Citizenship: true, P_Disabled: true, P_Family: true, P_LGBTQ: true,
                                   P_LowIncome: true, P_Native: true, P_Other: true, P_Senior: true, P_Veteran: true, PopulationTags: "poptags",
                                   ServiceAreaDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], ServiceAreaDescriptionDisplay: "sdescdisplay", S_Abuse: true, S_Addiction: true,
                                   S_BasicNeeds: true, S_Behavioral: true, S_CaseManagement: true, S_Clothing: true, S_DayCare: true, S_Disabled: true, S_Education: true, S_Emergency: true, S_Employment: true, S_Family: true, S_Financial: true,
                                   S_Food: true, S_GeneralSupport: true, S_Housing: true, S_Identification: true, S_IndependentLiving: true, S_Legal: true, S_Medical: true, S_Research: true, S_Resources: true, S_Respite: true, S_Senior: true, S_Transportation: true,
                                   S_Veterans: true, S_Victim: true, ServiceTags: "stags", ProgramComment: "comment",
                                   ProgramReferences: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], SelectprogramID: "new", ProgramSites: [1]}]}, email: user.email}
    end

    context "succesful with valid params" do
      before :each do
        post "/api/create_catalog", :params => params.to_json, :headers => { "CONTENT_TYPE" => "application/json"}
      end

      it "should be success" do
        expect(response).to have_http_status(:success)
      end

      it "should return json" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq ({"status"=>"ok", "message"=>"Entry created successfully"})
      end

      it "should not create invalid catalog entry for valid param" do
        expect(InvalidCatalogEntry.all.count).to eq 0
      end
    end

    context "with invalid params" do

      let(:invalid_params) do
        params[:catalog_data][:url] = "test "
        params
      end

      before :each do
        post "/api/create_catalog", :params => invalid_params.to_json, :headers => { "CONTENT_TYPE" => "application/json"}
      end

      it "should be success" do
        expect(response).to have_http_status(:success)
      end

      it "should return json" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq ({"status"=>"ok", "message"=>"Entry created successfully"})
      end

      it "should create invalid catalog entry for invalid param" do
        expect(InvalidCatalogEntry.all.count).to eq 1
      end

      it "should record error hash" do
        expect(InvalidCatalogEntry.all.first.error_hash).to eq ({"catalog_data"=>{"url"=>["is in invalid format"]}})
      end
    end
  end
end
