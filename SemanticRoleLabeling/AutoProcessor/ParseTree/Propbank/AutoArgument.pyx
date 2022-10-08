from AnnotatedSentence.ViewLayerType import ViewLayerType
from Dictionary.Word cimport Word
from PropBank.ArgumentType import ArgumentType
from PropBank.Frameset cimport Frameset
from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.ParseTreeDrawable cimport ParseTreeDrawable
from AnnotatedTree.Processor.Condition.IsTransferable cimport IsTransferable
from AnnotatedTree.Processor.NodeDrawableCollector cimport NodeDrawableCollector


cdef class AutoArgument:

    cdef object second_language

    cpdef bint autoDetectArgument(self, ParseNodeDrawable parseNode, object argumentType):
        pass

    def __init__(self, secondLanguage: ViewLayerType):
        self.second_language = secondLanguage

    cpdef autoArgument(self,
                       ParseTreeDrawable parseTree,
                       Frameset frameset):
        cdef list leaf_list
        cdef NodeDrawableCollector node_drawable_collector
        cdef ParseNodeDrawable parse_node
        node_drawable_collector = NodeDrawableCollector(parseTree.getRoot(), IsTransferable(self.second_language))
        leaf_list = node_drawable_collector.collect()
        for parse_node in leaf_list:
            if isinstance(parse_node, ParseNodeDrawable) and parse_node.getLayerData(ViewLayerType.PROPBANK) is None:
                for argument_type in ArgumentType:
                    if frameset.containsArgument(argument_type) and self.autoDetectArgument(parse_node, argument_type):
                        parse_node.getLayerInfo().setLayerData(ViewLayerType.PROPBANK,
                                                              ArgumentType.getPropbankType(argument_type))
                if Word.isPunctuationSymbol(parse_node.getLayerData(self.second_language)):
                    parse_node.getLayerInfo().setLayerData(ViewLayerType.PROPBANK, "NONE")
        parseTree.saveWithFileName()
