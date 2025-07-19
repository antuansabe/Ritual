import SwiftUI
@preconcurrency import WebKit

struct LegalView: UIViewRepresentable {
    let fileName: String        // "PrivacyPolicy" | "TermsOfService"
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = Bundle.main.url(forResource: fileName, withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            loadErrorHTML(in: webView)
        }
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // No need to reload on update
    }
    
    private func loadErrorHTML(in webView: WKWebView) {
        let errorHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    padding: 20px;
                    text-align: center;
                    background-color: #f8f9fa;
                }
                .error-container {
                    background: white;
                    padding: 40px;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    max-width: 400px;
                    margin: 50px auto;
                }
                h1 {
                    color: #e74c3c;
                    margin-bottom: 20px;
                }
                p {
                    color: #7f8c8d;
                    line-height: 1.6;
                }
            </style>
        </head>
        <body>
            <div class="error-container">
                <h1>Archivo no encontrado</h1>
                <p>No se pudo cargar el archivo: <strong>\(fileName).html</strong></p>
                <p>Por favor, contacta al soporte técnico.</p>
            </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
}

// Vista wrapper con navegación
struct LegalDocumentView: View {
    let fileName: String
    let title: String
    
    var body: some View {
        NavigationView {
            LegalView(fileName: fileName)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") {
                            // Se maneja automáticamente por NavigationLink
                        }
                    }
                }
        }
    }
}

#Preview {
    LegalView(fileName: "PrivacyPolicy")
}