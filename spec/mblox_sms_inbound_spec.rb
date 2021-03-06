require "rails/mblox"
require 'pry'

describe Rails::Mblox::SmsResponse do
  it 'parse inbound datas' do
    datas =
      <<-eos
    XMLDATA=<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
    <ResponseService Version="2.3">
        <Header>
        <Partner>Wizville</Partner>
        <Password>z5D3PVp4</Password>
    <ServiceID>1</ServiceID>
      </Header>
    <ResponseList>
    <Response SequenceNumber="1" Type="SMS">
        <TransactionID>131528441347</TransactionID>
          <OriginatingNumber>33613260437</OriginatingNumber>
    <Time>201409231319</Time>
          <Data>stop</Data>
    <Deliverer>1930</Deliverer>
          <Destination>36111</Destination>
    </Response>
      </ResponseList>
    </ResponseService>
    eos

    originating_number, data, msg_reference = Rails::Mblox::SmsInbound.from_xml(datas)
    originating_number.should == "33613260437"
    msg_reference.should == ""
    data.should == "stop"
  end

  it 'parse inbound stop' do
    datas =
        <<-eos
    XMLDATA=<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
    <ResponseService Version="2.3">
        <Header>
        <Partner>Wizville</Partner>
        <Password>z5D3PVp4</Password>
    <ServiceID>1</ServiceID>
      </Header>
    <ResponseList>
    <Response SequenceNumber="1" Type="SMS">
        <TransactionID>131528441347</TransactionID>
          <OriginatingNumber>33613260437</OriginatingNumber>
    <Time>201409231319</Time>
          <Data>stop</Data>
    <Deliverer>1930</Deliverer>
          <Destination>36111</Destination>
          <MsgReference>123456789</MsgReference>
    </Response>
      </ResponseList>
    </ResponseService>
    eos

    originating_number, data, msg_reference = Rails::Mblox::SmsInbound.from_xml(datas)
    originating_number.should == "33613260437"
    msg_reference.should == "123456789"
    data.should == "stop"
  end

  it 'parse inbound binary' do
    datas =
        <<-eos
    XMLDATA=<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
    <ResponseService Version="2.3">
        <Header>
        <Partner>Wizville</Partner>
        <Password>z5D3PVp4</Password>
    <ServiceID>1</ServiceID>
      </Header>
    <ResponseList>
    <Response SequenceNumber="1" Type="SMS" Format="Binary">
        <TransactionID>131528441347</TransactionID>
          <OriginatingNumber>33613260437</OriginatingNumber>
    <Time>201409231319</Time>
          <Data>2761696C6C6575727320212E2E2E506179657220706F757220EA74726520666964E86C652021766F7472652061766973206D27696E74E972657373652E2E2E</Data>
    <Deliverer>1930</Deliverer>
          <Destination>36111</Destination>
          <MsgReference>123456789</MsgReference>
    </Response>
      </ResponseList>
    </ResponseService>
    eos

    originating_number, data, msg_reference = Rails::Mblox::SmsInbound.from_xml(datas)
    originating_number.should == "33613260437"
    msg_reference.should == "123456789"
    data.should == "'ailleurs !...Payer pour \u00EAtre fid\u00E8le !votre avis m'int\u00E9resse..."
  end
end