require_relative 'config'

document_template = Eversign::Models::Template.new
document_template.template_id = Config.configuration.template_id
document_template.title = 'Title goes here'
document_template.message = 'my message'

signer = Eversign::Models::Signer.new('Jane Doe', 'signer@gmail.com', 'Client')
document_template.add_signer(signer)
signer = Eversign::Models::Signer.new('Jane Doe2', 'signer2@gmail.com', 'Partner')
document_template.add_signer(signer)

recipient = Eversign::Models::Recipient.new('Test', 'recipient@gmail.com', 'Partner')
document_template.add_recipient(recipient)
field = Eversign::Models::Field.new
field.identifier = Config.configuration.template_id
field.value = 'Merge Field Content'
document_template.add_field(field)

client = Eversign::Client.new
finished_document = client.create_document_from_template(document_template)
p(finished_document)
