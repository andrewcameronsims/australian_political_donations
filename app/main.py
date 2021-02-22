import streamlit as st
import pyTigerGraph as tg
from streamlit_agraph import agraph, Node, Edge, Config

graph = tg.TigerGraphConnection(username="tigergraph", password="tigergraph", graphname="australian_political_donations")


def donor_node(donor_dict):
  return Node(
    id = donor_dict['v_id'],
    label = donor_dict['attributes']['name'],
    size = 400
  )

def recipient_node(recipient_dict):
  return Node(
    id = recipient_dict['v_id'],
    label = recipient_dict['attributes']['party_name'],
    size = 400
  )

def donation_edge(donation_dict):
  return Edge(
    source = donation_dict['from_id'],
    label = donation_dict['attributes']['monetary_value'],
    target = donation_dict['to_id']
  )

st.title("Australian Political Donations, 2013-2020")

donors = graph.getVertices("donor")[0:100]
recipients = graph.getVertices("recipient")[0:100]
donations = graph.getEdgesByType("donation")[0:100]

donor_nodes = map(donor_node, donors)
recipient_nodes = map(recipient_node, recipients)
donation_edges = map(donation_edge, donations)

config = Config(
    width = 500,
    height = 500,
    directed = True,
    nodeHighlightBehavior = True,
    highlightColor = "#F7A7A6",
    collapsible = True,
    node = {'labelProperty':'label'},
    link = {'labelProperty': 'label', 'renderLabel': True}
  )

agraph(
    nodes = list(donor_nodes) + list(recipient_nodes),
    edges = donation_edges,
    config = config
  )
