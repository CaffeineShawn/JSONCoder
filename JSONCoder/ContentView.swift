import SwiftUI

struct ContentView: View {
    @State private var jsonString = ""
    @State private var jsonOutput = ""
    
    var body: some View {
        VStack {
            Text("JSON Decoder")
                .font(.title)
                .padding()
            
            Text("Enter JSON:")
            
            TextEditor(text: $jsonString)
                .frame(minWidth: 400, minHeight: 200)
                .padding()
            
            HStack {
                
                Button(action: decodeToJSON) {
                    Text("Decode to JSON")
                        .padding()
                }
                
                Button(action: copyToClipboard) {
                    Text("Copy to Clipboard")
                        .padding()
                }
            }
            
            TextEditor(text: $jsonOutput)
                .frame(minWidth: 400, minHeight: 200)
                .padding()
        }
    }
    
    private func decodeToJSON() {
        var str = jsonString.replacingOccurrences(of: "\\", with: "")
                            .replacingOccurrences(of: "\"{", with: "{")
                            .replacingOccurrences(of: "}\"", with: "}")
        let startIdx = jsonString.firstIndex(of: Character("{")) ?? str.startIndex
        let endIdx = jsonString.lastIndex(of: Character("}")) ?? str.endIndex
        str = String(str[startIdx..<min(endIdx, str.endIndex)])
        
        if let jsonObj = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!) {
            let jsonOutputData = try? JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
            
            jsonOutput = (String(data: jsonOutputData!, encoding: .utf8) ?? str)
                .replacing(/\\+\//, with: "/")
        }
        
        else {
            jsonOutput = str
        }
        
        
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
