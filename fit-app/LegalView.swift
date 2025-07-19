import SwiftUI
import WebKit

struct LegalView: UIViewRepresentable {
    let file: String
    
    init(file: String) {
        self.file = file
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        loadLocalHTML(in: webView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func loadLocalHTML(in webView: WKWebView) {
        guard let htmlPath = Bundle.main.path(forResource: file, ofType: "html", inDirectory: "Legal"),
              let htmlURL = URL(string: "file://\(htmlPath)") else {
            loadErrorHTML(in: webView)
            return
        }
        
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
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
                <p>No se pudo cargar el archivo: <strong>\(file).html</strong></p>
                <p>Por favor, contacta al soporte técnico.</p>
            </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: LegalView
        
        init(_ parent: LegalView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Opcional: Ajustar el zoom o configuraciones adicionales
            webView.evaluateJavaScript("document.body.style.webkitTextSizeAdjust='100%'")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load legal document: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Permitir navegación solo a archivos locales
            if let url = navigationAction.request.url,
               url.scheme == "file" || url.absoluteString.contains("Legal/") {
                decisionHandler(.allow)
            } else {
                // Para enlaces externos, abrir en Safari
                if let url = navigationAction.request.url {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
            }
        }
    }
}

// Vista wrapper con navegación
struct LegalDocumentView: View {
    let file: String
    let title: String
    
    var body: some View {
        NavigationView {
            LegalView(file: file)
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
    LegalView(file: "PrivacyPolicy")
}